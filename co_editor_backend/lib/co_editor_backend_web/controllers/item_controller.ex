defmodule CoEditorBackendWeb.ItemController do
    use CoEditorBackendWeb, :controller


    def index(conn, %{"username" => username, "token" => token}) do
        # 这个函数返回的是所有的doc名字
        total_doc_table = 
            CoEditorBackend.Repo.all(CoEditorBackend.Room) 
            |> Enum.map(fn room -> %{id: room.id, doc_name: room.doc_name, doc_room: room.doc_room} end)
        response = %{status: true, data: total_doc_table}
        conn 
        |> put_status(:ok)
        |> json(response)
    end

    def create(conn, %{"docname" => docname, "docroom" => docroom}) do
        # 这个是post请求，用来处理文档创建
        %CoEditorBackend.Room{"doc_name": docname, "doc_room": docroom}
        |> CoEditorBackend.Repo.insert()
        response = %{status: true}
        conn
        |> put_status(:ok)
        |> json(response)
    end

end
