defmodule CoEditorBackend.AiGenCache do
    use GenServer
    def init(_) do
        IO.puts("ai gen cache start!")
        {:ok, Map.new()}
    end

    def handle_call({:ai_worker, %{"user_id"=>user_id}}, _ai_server_pid, state) do
        # 这个函数是当CoEditorBackEndWeb中的Controller调用的时候进入
        # 如果这个user_id不在Map中，则专门生成一个新的AIServer服务这次调用，否则就用过去的
        pid = case Map.has_key?(state, user_id) do
            false -> 
                # 创建一个ai server，然后访问
                {:ok, pid} = CoEditorBackend.AiWorker.start_link()
                Map.put(state, user_id, pid)
                pid
            _ ->
                Map.get(state, user_id)
        end
        {:reply, pid, state}
    end


    def start_link(args) do
        GenServer.start_link(__MODULE__, args, name: :ai_gen_cache)
    end


    def get_worker_pid(%{"user_id"=>user_id}) do
        GenServer.call(:ai_gen_cache, {:ai_worker, %{"user_id" => user_id}})
    end
end