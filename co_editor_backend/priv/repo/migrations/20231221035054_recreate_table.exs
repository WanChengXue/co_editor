defmodule CoEditorBackend.Repo.Migrations.RecreateTable do
  use Ecto.Migration

  def change do
    drop table(:doc)
    create table(:doc) do
      add :doc_name, :string
      add :doc_room, :string
      add :doc_content, :string
      end
  end
end
