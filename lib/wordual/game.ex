defmodule Wordual.Game do
  use GenServer
  @registry Wordual.GameRegistry
  @supervisor Wordual.GameSupervisor

  def start(game_id) do
    opts = [
      game_id: game_id,
      name: {:via, Registry, {@registry, game_id}}
    ]

    DynamicSupervisor.start_child(@supervisor, {__MODULE__, opts})
  end

  def lookup(game_id) do
    case Registry.lookup(@registry, game_id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  def start_link(opts) do
    {name, opts} = Keyword.pop(opts, :name)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init(opts) do
    {:ok, %{game_id: Keyword.fetch!(opts, :game_id)}}
  end
end
