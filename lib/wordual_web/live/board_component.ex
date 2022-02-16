defmodule WordualWeb.Live.BoardComponent do
  use Phoenix.Component

  def show(assigns) do
    board =
      assigns.game
      |> Map.get(:boards)
      |> Map.get(assigns.id)

    assigns = assign(assigns, :board, board)

    ~H"""
    <div class="board grid grid-rows-4 gap-[5px] box-border p-1">
    <%= for row <- @board.rows do %>
      <div class="grid grid-cols-5 gap-[5px]">
      <%= for tile <- row.tiles do %>
        <div class={tile_class(tile)}>
          <%= tile.char %>
        </div>
      <% end %>
      </div>
    <% end %>
    </div>
    """
  end

  def tile_class(tile) do
    "#{Atom.to_string(tile.state)} tile"
  end
end
