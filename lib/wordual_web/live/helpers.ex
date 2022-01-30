defmodule WordualWeb.Live.Helpers do
  alias Wordual.Game

  def other_player(game, player_id) do
    Game.other_player(game, player_id)
  end
end
