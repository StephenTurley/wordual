defmodule Wordual.GameServer do
  use GenServer
  @registry Wordual.GameRegistry
  @supervisor Wordual.GameSupervisor
  @pubsub Wordual.PubSub

  alias Wordual.Game

  @impl true
  def init(opts) do
    {:ok, %Game{id: Keyword.fetch!(opts, :game_id)}}
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
    Phoenix.PubSub.subscribe(@pubsub, game_id)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def add_char(pid, player_id, char) do
    GenServer.call(pid, {:add_char, player_id, char})
  end

  # Callbacks

  @impl true
  def handle_call({:join, player_id}, _from, game) do
    Phoenix.PubSub.broadcast!(@pubsub, game.id, {:game_updated, player_id, game.id})
    game = Game.join(game, player_id)
    {:reply, {:ok, game}, game}
  end

  @impl true
  def handle_call(:get, _from, game), do: {:reply, {:ok, game}, game}

  @impl true
  def handle_call({:add_char, player_id, char}, _from, game) do
    Phoenix.PubSub.broadcast!(@pubsub, game.id, {:game_updated, player_id, game.id})

    case Game.add_char(game, player_id, char) do
      {:ok, game} ->
        {:reply, {:ok, game}, game}

      error ->
        {:reply, error, game}
    end
  end
end
