defmodule Wordual do
  @moduledoc """
  Wordual keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Wordual.GameServer

  def start_game(player_id) do
    id = Ecto.UUID.generate()
    {:ok, pid} = GameServer.start(id)
    GameServer.join(pid, player_id)
  end

  def join_game(game_id, player_id) do
    {:ok, pid} = GameServer.lookup(game_id)
    GameServer.join(pid, player_id)
  end
end
