defmodule WordualWeb.Live.BoardComponent do
  use WordualWeb, :live_component

  def render(%{game_id: game_id, id: player_id}) do
    {:ok, game} = Wordual.get_game(game_id)

    board =
      game
      |> Map.get(:players)
      |> Map.get(player_id)

    assigns = %{board: board}

    ~H"""
    <div class="board">
    <%= for row <- @board do %>
      <div class="row grid grid-cols-5">
      <%= for _tile <- row do %>
        <div class="tile border">A</div>
      <% end %>
      </div>
    <% end %>
    </div>
    """
  end
end
