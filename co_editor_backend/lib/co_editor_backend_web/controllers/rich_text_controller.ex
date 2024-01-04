defmodule CoEditorBackendWeb.RichTextController do
    use CoEditorBackendWeb, :controller

    def ai(conn, params) do
        prompt = handle_rich_context(params)
        user_id = user_id_generate(user_name)
        server_pid = CoEditorBackend.AiGenCache.get_worker_pid(%{"user_id"=>user_id})
        response = CoEditorBackend.AiWorker.call_ai(%{"ai_server_pid"=>server_pid,"prompt"=>prompt})

        conn
        |> put_status(:ok)
        |> json(response)
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