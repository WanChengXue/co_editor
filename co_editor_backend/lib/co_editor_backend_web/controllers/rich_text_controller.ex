defmodule CoEditorBackendWeb.RichTextController do
  use CoEditorBackendWeb, :controller
  use Tesla

  def check_status(id) do
    # 查看该doc是否正在REPL
    RedisClient.start_link()
    # 0 : idle
    # 1 : busy
    result = RedisClient.command("GET", ["0"])
    RedisClient.command("SET", [id, "0"])
  end

  @doc """
  处理 doc content 的入口路由
    id: doc id
  """
  def content_gateway(conn, %{
        "user_id" => user_id,
        "doc_id" => doc_id,
        "doc_content" => doc_content
      }) do
    response = content_handler(user_id, doc_content)

    conn
    |> put_status(:ok)
    |> json(response)
  end

  @doc """
  segment doc_content with /n, find /ai index, send llm request
  """
  def content_handler(user_id, doc_content) do
    split_content = doc_content |> String.split("\n", trim: true)
    split_content_with_newline = Enum.map(split_content, &(&1 <> "\n"))
    #   # index 为 /ai 下标
    #   # index - 1 为 prompt 下标
    ai_indices = find_ai_indices(split_content_with_newline)

    result_content =
      Enum.with_index(split_content_with_newline)
      |> Enum.map(fn {element, index} ->
        handle_element(element, split_content_with_newline, index, user_id)
      end)

    merged_str = result_content |> List.flatten() |> Enum.join()

    merged_str
  end

  defp handle_element("/ai\n", context, index, user_id) do
    result = handle_ai_element(index, context, user_id)
    result
  end

  defp handle_element(element, _context, _index, _user_id) do
    element
  end

  @doc """

  """
  defp find_ai_indices(context) do
    context
    |> Enum.with_index()
    |> Enum.filter(fn {element, _index} -> String.contains?(element, "/ai\n") end)
    |> Enum.map(fn {_element, index} -> index end)
  end

  defp handle_ai_element(nil, _context, user_id) do
    IO.puts("'/ai' not found in context")
  end

  defp handle_ai_element(0, _context, user_id) do
    IO.puts("No previous element before '/ai'")
  end

  defp handle_ai_element(k, context, user_id) when k > 0 do
    previous_element = Enum.at(context, k - 1)
    response = ai_handler(previous_element, user_id)

    response
  end

  def ai_handler(element, user_id) do
    prompt = element
    server_pid = CoEditorBackend.AiGenCache.get_worker_pid(%{"user_id" => user_id})

    response =
      CoEditorBackend.AiWorker.call_ai(%{"ai_server_pid" => server_pid, "prompt" => prompt})

    response_with_linebreak = response <> "\n"
  end

  @doc """
  投票决策的访问任务发送给 aiworker
  """
  def ai_handler_vote(element, user_id) do
    prompt = element
    server_pid = CoEditorBackend.AiGenCache.get_worker_pid(%{"user_id" => user_id})

    response =
      CoEditorBackend.AiWorker.call_ai_vote(%{"ai_server_pid" => server_pid, "prompt" => prompt})

    # 获取 winner_answer
    winner = response["winner_id"]
    answers = response["answer_list"]
    winner_answer = answers[winner] <> "\n"
    winner_answer
  end

  defp user_id_generate(user_name) do
    binary = :crypto.hash(:sha256, user_name)
    id = Base.encode16(binary, case: :lower)
    id
  end

  defp handle_rich_context() do
    # TODO 处理文本参数，解析出prompt
  end
end
