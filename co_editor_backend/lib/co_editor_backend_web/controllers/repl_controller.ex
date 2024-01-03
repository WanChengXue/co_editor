alias CoEditorBackendWeb.RedisClient, as: RedisClient

defmodule CoEditorBackendWeb.ReplController do
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
  """
  def content_gateway(conn, %{"id" => id, "doccontent" => doc_content}) do
    content_handler(doc_content)
    response = %{status: true}

    conn
    |> put_status(:ok)
    |> json(response)
  end

  @doc """
  segment doc_content with /n, find /ai index, send llm request
  """
  def content_handler(doc_content) do
    split_content = doc_content |> String.split("\n", trim: true)
    ai_indices = find_ai_indices(split_content)

    # TODO: 缺少 /table, /img 的支持
    Enum.each(ai_indices, fn index ->
      handle_ai_element(index, split_content)
    end)
    # IO.inspect(
    #   doc_content
    #   |> String.split("\n", trim: true)
    #   |> find_ai_indices
    #   # |> Enum.each(fn index -> handle_ai_element(index, doc_content) end)
    # )
  end

  @doc """

  """
  defp find_ai_indices(context) do
    context
    |> Enum.with_index()
    |> Enum.filter(fn {element, _index} -> String.contains?(element, "/ai") end)
    |> Enum.map(fn {_element, index} -> index end)
  end

  defp handle_ai_element(nil, _context) do
    IO.puts("'/ai' not found in context")
  end

  defp handle_ai_element(0, _context) do
    IO.puts("No previous element before '/ai'")
  end

  defp handle_ai_element(k, context) when k > 0 do
    previous_element = Enum.at(context, k - 1)
    ai_handler(previous_element)
  end

  defp ai_handler(element) do
    url = "http://127.0.0.1:8000/jury"
    headers = [{"Content-Type", "application/json"}]
    body = %{question: element}

    # Tesla.post(url, body |> Jason.encode!(), headers)
    # |> case do
    #   {:ok, response} ->
    #     IO.puts("请求成功")
    #     # 解码 JSON 字符串为 Elixir 的 Map
    #     map = Jason.decode!(response)
    #     IO.inspect(map)
    #     # # 访问 "message" 字段
    #     # message = map["message"]

    #     # # 解码 "message" 字段的值为 Elixir 的 Map
    #     # message_map = Jason.decode!(message)

    #     # # 访问 "winner_id" 字段
    #     # winner_id = message_map["winner_id"]

    #     # IO.inspect(message)
    #     # IO.inspect(winner_id)
    #   {:ok, %{status_code: 200, body: body}} ->
    #     IO.puts("请求成功")
    #     IO.inspect(body)
    #   {:ok, %{status_code: status_code, body: body}} ->
    #     IO.puts("请求失败")
    #     IO.inspect(status_code)
    #     IO.inspect(body)
    #   {:error, reason} ->
    #     IO.puts("请求失败")
    #     IO.inspect(reason)
    # end
  end

  def typeof(self) do
    cond do
      is_float(self) -> "float"
      is_number(self) -> "number"
      is_atom(self) -> "atom"
      is_boolean(self) -> "boolean"
      is_binary(self) -> "binary"
      is_function(self) -> "function"
      is_list(self) -> "list"
      is_tuple(self) -> "tuple"
      true -> "idunno"
    end
  end
end
