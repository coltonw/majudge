defmodule Majudge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # Majudge.Repo,
      # DynamicSupervisor which runs AWS related tasks
      {DynamicSupervisor, name: Majudge.SleepRDSSupervisor, strategy: :one_for_one},
      # KeepAlive task which keeps RDS alive when needed then puts it to sleep when not
      Majudge.SleepRDS.KeepAlive,
      # Start the endpoint when the application starts
      MajudgeWeb.Endpoint
      # Starts a worker by calling: Majudge.Worker.start_link(arg)
      # {Majudge.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Majudge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MajudgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
