defmodule CoEditorBackendWeb.PageController do
  use CoEditorBackendWeb, :controller


  def handle_post(conn, _params) do
    case Plug.Conn.read_body(conn) do
      {:ok, body, _conn} ->
        case Jason.decode(body) do
          {:ok, data} ->
            IO.inspect(data)

            # TODO: 存储到数据库，返回响应等

            conn
            |> put_status(:ok)
            |> text("POST request received")

          {:error, _} ->
            conn
            |> put_status(:bad_request)
            |> text("Invalid JSON data")
        end

      {:error, _reason, conn} ->
        conn
        |> put_status(:bad_request)
        |> text("Invalid request body")
    end
  end
end
