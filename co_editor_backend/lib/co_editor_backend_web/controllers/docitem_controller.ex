defmodule DocitemController do
    use CoEditorBackendWeb, :controller


    def index(conn, %{"username" => username, "token" => token}) do
        # 这个函数返回的是所有的doc名字
        response = %{status: true}
        conn 
        |> put_status(:ok)
        |> json(response)
    end


    def create(conn, %{"docname" => docname, "docromm" => docroom}) do
        # 这个是post请求，用来处理文档创建
        # %CoEditorBackend.Room{"doc_name": docname, "doc_room": docroom}
        # |> CoEditorBackend.Repo.insert()
        response = %{status: true}
        conn
        |> put_status(:ok)
        |> json(response)
    end

end