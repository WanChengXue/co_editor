defmodule CoEditorBackend.Repo do
    use Ecto.Repo,
    otp_app: :co_editor_backend,
    adapter: Ecto.Adapters.SQLite3
end


defmodule CoEditorBackend.User do
    use Ecto.Schema

    schema "user" do
        field :username, :string
        field :password, :string
    end
end


defmodule CoEditorBackend.Room do
    use Ecto.Schema

    schema "room" do
        field :doc_name, :string
        field :doc_room, :string
    end
end
