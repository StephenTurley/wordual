defmodule WordualWeb.Live.BoardComponent do
  use Phoenix.Component

  def show(assigns) do
    board =
      assigns.game
      |> Map.get(:boards)
      |> Map.get(assigns.id)

    assigns = assign(assigns, :board, board)

    ~H"""
    <div class="board">
    <%= for row <- @board.rows do %>
      <div class="row grid grid-cols-5">
      <%= for tile <- row.tiles do %>
        <div class="tile border p-2 m-1">
          <%= tile.char %>
        </div>
      <% end %>
      </div>
    <% end %>
    </div>
    """
  end
end
