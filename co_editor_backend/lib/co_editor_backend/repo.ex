defmodule CoEditorBackend.Repo do
  use Ecto.Repo,
    otp_app: :co_editor_backend,
    adapter: Ecto.Adapters.Postgres
end
