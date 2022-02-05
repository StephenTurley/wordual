defmodule Wordual.Row do
  defstruct [:current_tile, :tiles]
  @max_tiles 5

  alias Wordual.Tile

  def init() do
    %__MODULE__{
      current_tile: 0,
      tiles: Enum.map(1..@max_tiles, fn _ -> Tile.init() end)
    }
  end

  def add_char(%{current_tile: @max_tiles}, _), do: {:error, :row_full}

  def add_char(%{current_tile: current_tile, tiles: tiles}, char) do
    {:ok,
     %__MODULE__{
       current_tile: current_tile + 1,
       tiles: List.replace_at(tiles, current_tile, Tile.for_char(char))
     }}
  end
end
