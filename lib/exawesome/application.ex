defmodule Exawesome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Exawesome.Repo,
      # Start the Telemetry supervisor
      ExawesomeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exawesome.PubSub},
      # Start the Endpoint (http/https)
      ExawesomeWeb.Endpoint,
      Exawesome.Scheduler
      # Start a worker by calling: Exawesome.Worker.start_link(arg)
      # {Exawesome.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exawesome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExawesomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
