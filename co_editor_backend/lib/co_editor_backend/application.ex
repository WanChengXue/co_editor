defmodule CoEditorBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CoEditorBackendWeb.Telemetry,
      # Start the Ecto repository
      CoEditorBackend.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CoEditorBackend.PubSub},
      # Start Finch
      {Finch, name: CoEditorBackend.Finch},
      # Start the Endpoint (http/https)
      CoEditorBackendWeb.Endpoint,
      # Start a worker by calling: CoEditorBackend.Worker.start_link(arg)
      # {CoEditorBackend.Worker, arg}
      CoEditorBackend.AiGenSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoEditorBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CoEditorBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
