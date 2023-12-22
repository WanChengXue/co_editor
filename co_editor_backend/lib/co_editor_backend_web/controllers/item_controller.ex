defmodule CoEditorBackendWeb.ItemController do
    use CoEditorBackendWeb, :controller


    def index(conn, %{"username" => username, "token" => token}) do
        # 这个函数返回的是所有的doc名字
        total_doc_table =
            CoEditorBackend.Repo.all(CoEditorBackend.Doc)
            |> Enum.map(fn room -> %{id: room.id, doc_name: room.doc_name, doc_room: room.doc_room} end)
        response = %{status: true, data: total_doc_table}
        conn
        |> put_status(:ok)
        |> json(response)
    end

    def create(conn, %{"docname" => docname, "docroom" => docroom}) do
        # TODO: doc_room 不能重复
        # 给doc数据库增加一条数据
        %CoEditorBackend.Doc{"doc_name": docname, "doc_room": docroom, "doc_content": ""}
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
        case CoEditorBackend.Repo.get_by(CoEditorBackend.Doc, id: id) do
            nil ->
                response = %{status: "error", message: "未找到满足条件的文档"}
                conn
                |> put_status(:not_found)
                |> json(response)

            doc ->
                changeset = CoEditorBackend.Doc.changeset(doc, %{doc_content: doccontent, doc_name: docname, doc_room: docroom})
                case CoEditorBackend.Repo.update(changeset) do
                    {:ok, _updated_doc} ->
                        response = %{status: "success"}
                        conn
                        |> put_status(:ok)
                        |> json(response)

                    {:error, changeset} ->
                        response = %{status: "error", message: "更新文档失败", errors: changeset.errors}
                        conn
                        |> put_status(:unprocessable_entity)
                        |> json(response)
                end
        end
    end
end
