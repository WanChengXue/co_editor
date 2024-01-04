defmodule CoEditorBackend.AiWorker do
    use GenServer
    def init(_) do
        {:ok, %{}}
    end

    def handle_call({:ai ,%{"ai_server_pid"=>pid,"prompt"=>prompt}}, _from, state) do
        IO.puts("收到了prompt #{prompt}!")
        # TODO, mock 数据修改为http访问
        result = %{
                    "answers"=> %{
                        "1" => "answer1",
                        "2" => "answer2",
                        "gpt" => "answer3"
                    },
                "winner" => "1"
                }
        {:reply, result, state}
    end

    def start_link() do
        GenServer.start_link(__MODULE__, nil)
    end

    def call_ai(%{"ai_server_pid"=>pid,"prompt"=>prompt}) do
        GenServer.call(pid, {:ai, %{"ai_server_pid"=>pid,"prompt"=>prompt}})
    end
end