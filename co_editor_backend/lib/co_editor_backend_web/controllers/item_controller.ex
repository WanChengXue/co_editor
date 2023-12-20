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

        # 同时给doc数据库增加一条数据
        %CoEditorBackend.Doc{"doc_name": docname, "room_name": docroom, "doc_content": "Untitled"}
        |> CoEditorBackend.Repo.insert()

        response = %{status: true}
        conn
        |> put_status(:ok)
        |> json(response)
    end


    def show(conn, %{"id" => id}) do
        case CoEditorBackend.Repo.get(CoEditorBackend.Doc, id) do
            nil ->
            response = %{status: "error", message: "不存在该id的文档"}
            conn
            |> put_status(:not_found)
            |> json(response)

            doc ->
            response = %{status: "success", doc_content: doc.doc_content}
            conn
            |> put_status(:ok)
            |> json(response)
        end
    end


    def update(conn, %{"id" => id, "doccontent" => doccontent, "docname" => docname, "docroom" => docroom}) do
        case CoEditorBackend.Repo.get_by(CoEditorBackend.Doc, doc_name: docname, room_name: docroom) do
            nil ->
                response = %{status: "error", message: "未找到满足条件的文档"}
                conn
                |> put_status(:not_found)
                |> json(response)

            doc ->
                updated_doc = %CoEditorBackend.Doc{doc | doc_content: doccontent}
                {:ok, _} = CoEditorBackend.Repo.update(updated_doc)
                
                response = %{status: "success"}
                conn
                |> put_status(:ok)
                |> json(response)
        end
    end
end
