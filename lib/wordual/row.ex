defmodule Wordual.Row do
  defstruct [:current_tile, :tiles]
  @max_tiles 5

  alias Wordual.Tile
  alias Wordual.Words

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

  def clear_char(%{current_tile: 0}), do: {:error, :row_empty}

  def clear_char(%{current_tile: current_tile, tiles: tiles}) do
    current_tile = current_tile - 1

    {:ok,
     %__MODULE__{
       current_tile: current_tile,
       tiles: List.replace_at(tiles, current_tile, Tile.init())
     }}
  end

  def check_row(%{current_tile: current_tile}, _word) when current_tile < @max_tiles,
    do: {:error, :incomplete_word}

  def check_row(%{tiles: tiles}, word) do
    word_to_check = Enum.map_join(tiles, "", &Map.get(&1, :char))

    cond do
      word_to_check == word -> {:ok, :correct}
      Words.valid_word?(word_to_check) -> {:ok, :valid_word}
      true -> {:error, :invalid_word}
    end
  end

  def update_row_state(row, word) do
    Map.replace!(
      row,
      :tiles,
      Enum.with_index(row.tiles, fn tile, index ->
        cond do
          String.at(word, index) == tile.char -> Tile.is_correct(tile)
          String.contains?(word, tile.char) -> Tile.is_present(tile)
          true -> Tile.is_absent(tile)
        end
      end)
    )
  end
end
