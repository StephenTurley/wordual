defmodule Wordual.GameServer do
  use GenServer
  require Logger

  alias Wordual.Game
  alias Wordual.Words

  @registry Wordual.GameRegistry
  @supervisor Wordual.GameSupervisor
  @pubsub Wordual.PubSub

  @impl true
  def init(opts) do
    {:ok, Game.init(Keyword.fetch!(opts, :game_id), Words.random_word())}
  end

  def start(game_id) do
    opts = [
      game_id: game_id,
      name: {:via, Horde.Registry, {@registry, game_id}}
    ]

    Horde.DynamicSupervisor.start_child(@supervisor, {__MODULE__, opts})
  end

  def lookup(game_id) do
    case Horde.Registry.lookup(@registry, game_id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  def start_link(opts) do
    {name, opts} = Keyword.pop(opts, :name)
    {:ok, pid} = GenServer.start_link(__MODULE__, opts, name: name)
    Process.send_after(pid, :tick, 1000)
    {:ok, pid}
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

  def clear_char(pid, player_id) do
    GenServer.call(pid, {:clear_char, player_id})
  end

  def submit_row(pid, player_id) do
    GenServer.call(pid, {:submit_row, player_id})
  end

  def restart(pid, player_id) do
    GenServer.call(pid, {:restart, player_id})
  end

  # Callbacks

  @impl true
  def handle_info(:tick, game) do
    game = Game.tick(game, 1000)

    if game.ttl <= 0 do
      Logger.info("Game: #{game.id} timed out")
      DynamicSupervisor.terminate_child(@supervisor, self())
      {:stop, :shutdown, game}
    else
      Process.send_after(self(), :tick, 1000)
      {:noreply, game}
    end
  end

  @impl true
  def handle_call({:restart, player_id}, _from, game) do
    Logger.info("Player #{player_id} restarted the game #{game.id}")
    other_player = Game.other_player(game, player_id)

    game =
      Game.init(game.id, Words.random_word())
      |> Game.join(player_id)
      |> Game.join(other_player)
      |> Game.save_statistics(game.statistics)

    Phoenix.PubSub.broadcast!(@pubsub, game.id, {:game_updated, player_id, game.id})
    {:reply, {:ok, game}, game}
  end

  @impl true
  def handle_call({:join, player_id}, _from, %{state: :starting} = game) do
    Logger.info("Player #{player_id} joined the game #{game.id}")

    Phoenix.PubSub.broadcast!(@pubsub, game.id, {:game_updated, player_id, game.id})
    game = Game.join(game, player_id)
    {:reply, {:ok, game}, game}
  end

  @impl true
  def handle_call({:join, player_id}, _from, game) do
    Logger.info("Player #{player_id} joined a running game #{game.id}")

    if Map.has_key?(game.boards, player_id) do
      {:reply, {:ok, game}, game}
    else
      {:reply, {:error, :game_full}, game}
    end
  end

  @impl true
  def handle_call(:get, _from, game), do: {:reply, {:ok, game}, game}

  @impl true
  def handle_call({:add_char, player_id, char}, _from, game) do
    Logger.info("Player #{player_id} added a character '#{char}'")
    update_game(game, player_id, Game.add_char(game, player_id, char))
  end

  @impl true
  def handle_call({:clear_char, player_id}, _from, game) do
    Logger.info("Player #{player_id} deleted a character")
    update_game(game, player_id, Game.clear_char(game, player_id))
  end

  @impl true
  def handle_call({:submit_row, player_id}, _from, game) do
    Logger.info("Player #{player_id} submitted a row")
    update_game(game, player_id, Game.submit_row(game, player_id))
  end

  defp update_game(game, player_id, result) do
    Phoenix.PubSub.broadcast!(@pubsub, game.id, {:game_updated, player_id, game.id})

    case result do
      {:ok, game} ->
        {:reply, {:ok, game}, game}

      error ->
        {:reply, error, game}
    end
  end
end
