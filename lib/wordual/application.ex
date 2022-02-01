defmodule Wordual.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Wordual.Repo,
      WordualWeb.Telemetry,
      {Phoenix.PubSub, name: Wordual.PubSub},
      WordualWeb.Endpoint,
      {Registry, keys: :unique, name: Wordual.GameRegistry},
      {DynamicSupervisor, name: Wordual.GameSupervisor, strategy: :one_for_one}
    ]

    opts = [strategy: :one_for_one, name: Wordual.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    WordualWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
