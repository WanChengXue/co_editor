defmodule CoEditorBackend.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:room) do
        add :doc_name, :string
        add :doc_room, :string
    end
  end
end
