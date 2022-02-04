defmodule Wordual.Row do
  defstruct [:current_tile, :tiles]

  alias Wordual.Tile

  def init() do
    %__MODULE__{
      current_tile: 0,
      tiles: Enum.map(0..4, fn _ -> Tile.init() end)
    }
  end
end
