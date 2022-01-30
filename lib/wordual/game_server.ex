defmodule Wordual.GameServer do
  use GenServer
  @registry Wordual.GameRegistry
  @supervisor Wordual.GameSupervisor

  defstruct [:game_id, :player_1, :player_2]

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
    {:ok, %__MODULE__{game_id: Keyword.fetch!(opts, :game_id)}}
  end

  def join(pid, player_id) do
    GenServer.call(pid, {:join, player_id})
  end

  # Callbacks

  @impl true
  def handle_call({:join, player_id}, _from, %{player_1: player_1, player_2: player_2} = game) do
    cond do
      player_1 == nil ->
        game = Map.put(game, :player_1, player_id)
        {:reply, {:ok, game}, game}

      player_2 == nil ->
        game = Map.put(game, :player_2, player_id)
        {:reply, {:ok, game}, game}

      true ->
        {:reply, {:ok, game}, game}
    end
  end
end
