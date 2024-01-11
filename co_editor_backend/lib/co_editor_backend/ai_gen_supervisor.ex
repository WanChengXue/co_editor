defmodule CoEditorBackend.AiGenSupervisor do
    use Supervisor

    def start_link(arg) do
        Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
    end

    def init(_) do
        IO.puts("Ai Gen Supervisor start!")
        children = [
        CoEditorBackend.AiGenCache
        # 添加其他要启动的子进程
        ]
        Supervisor.init(children, strategy: :one_for_one)
    end
end