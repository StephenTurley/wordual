defmodule Wordual.GameServer do
  use GenServer
  @registry Wordual.GameRegistry
  @supervisor Wordual.GameSupervisor

  defstruct [:game_id, :player_1, :player_2]

  @impl true
  def init(opts) do
    {:ok, %__MODULE__{game_id: Keyword.fetch!(opts, :game_id)}}
  end

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

  def join(pid, player_id) do
    GenServer.call(pid, {:join, player_id})
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(Wordual.PubSub, game_id)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  # Callbacks

  @impl true
  def handle_call({:join, player_id}, _from, %{player_1: player_1, player_2: player_2} = game) do
    Phoenix.PubSub.broadcast!(
      Wordual.PubSub,
      game.game_id,
      {:player_joined, player_id, game.game_id}
    )

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

  @impl true
  def handle_call(:get, _from, game), do: {:reply, {:ok, game}, game}
end
