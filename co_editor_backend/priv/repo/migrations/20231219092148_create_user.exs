defmodule CoEditorBackend.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
        add :username, :string, null: false
        add :password, :string, null: false
    end
  end
end
