defmodule CoEditorBackend.AiWorker do
  use GenServer

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:ai_vote, %{"ai_server_pid" => pid, "prompt" => prompt}}, _from, state) do
    # IO.puts("收到了prompt #{prompt}!")
    url = "http://127.0.0.1:8000/api/jury"
    headers = [{"Content-Type", "application/json"}]
    body = %{question: prompt}
    IO.puts("请求发送")

    result =
      Tesla.post(url, body |> Jason.encode!(), headers)
      |> case do
        {:ok, response} ->
          IO.puts("请求成功")
          parsed_map = Poison.decode!(response.body)
          decoded_data = Jason.decode!(parsed_map)
          IO.inspect(decoded_data)
          decoded_data
        # {:ok, %{status_code: 200, body: body}} ->
        #   IO.puts("请求成功")

        {:ok, %{status_code: status_code, body: body}} ->
          IO.puts("请求失败")
          IO.inspect(status_code)
          IO.inspect(body)

        {:error, reason} ->
          IO.puts("请求失败")
          IO.inspect(reason)
      end

    # result = %{
    #   "answer_list" => %{
    #     "1" => "answer1",
    #     "2" => "answer2",
    #     "gpt" => "answer3"
    #   },
    #   "winner_id" => "1"
    # }
    {:reply, result, state}
  end

  def handle_call({:ai, %{"ai_server_pid" => pid, "prompt" => prompt}}, _from, state) do
    url = "http://127.0.0.1:8000/api/query"
    headers = [{"Content-Type", "application/json"}]
    body = %{question: prompt}

    result =
      Tesla.post(url, body |> Jason.encode!(), headers)
      |> case do
        {:ok, response} ->
          IO.puts("请求成功")
          parsed_map = Poison.decode!(response.body)
          decoded_data = Jason.decode!(parsed_map)
          decoded_data["answer"]
        # {:ok, %{status_code: 200, body: body}} ->
        #   IO.puts("请求成功")

        {:ok, %{status_code: status_code, body: body}} ->
          IO.puts("请求失败")
          IO.inspect(status_code)
          IO.inspect(body)

        {:error, reason} ->
          IO.puts("请求失败")
          IO.inspect(reason)
      end
    {:reply, result, state}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def call_ai(%{"ai_server_pid" => pid, "prompt" => prompt}) do
    timeout = 10 * 60 * 1000
    GenServer.call(pid, {:ai, %{"ai_server_pid" => pid, "prompt" => prompt}}, timeout)
  end

  def call_ai_vote(%{"ai_server_pid" => pid, "prompt" => prompt}) do
    timeout = 10 * 60 * 1000
    GenServer.call(pid, {:ai_vote, %{"ai_server_pid" => pid, "prompt" => prompt}}, timeout)
  end
end
