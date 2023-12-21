defmodule CoEditorBackend.Repo.Migrations.CreateDoc do
  use Ecto.Migration

  def change do
    create table(:doc) do
      add :doc_name, :string
      add :doc_room, :string
      add :doc_content, :string
    end
  end
end
