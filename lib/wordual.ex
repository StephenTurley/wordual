defmodule Wordual do
  @moduledoc """
  Wordual keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Wordual.GameServer

  def start_game(player_id) do
    game_id = Ecto.UUID.generate()
    {:ok, pid} = GameServer.start(game_id)
    GameServer.subscribe(game_id)
    GameServer.join(pid, player_id)
  end

  def join_game(game_id, player_id) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.subscribe(game_id)
    GameServer.join(pid, player_id)
  end

  def get_game(game_id) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.get(pid)
  end

  def add_char(game_id, player_id, char) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.add_char(pid, player_id, char)
  end

  def clear_char(game_id, player_id) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.clear_char(pid, player_id)
  end

  def submit_row(game_id, player_id) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.submit_row(pid, player_id)
  end
end
