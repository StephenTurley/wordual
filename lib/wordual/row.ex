defmodule Wordual.Row do
  defstruct [:current_tile, :tiles]
  @max_tiles 5

  alias Wordual.Tile
  alias Wordual.Words

  def init do
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
    {:ok, Map.replace!(row, :tiles, update_tiles(row.tiles, word))}
  end

  defp update_tiles(tiles, word) do
    word = String.split(word, "", trim: true)

    # find all correct
    {tiles, found} =
      tiles
      |> Enum.with_index()
      |> Enum.map_reduce([], fn {tile, index}, found ->
        if Enum.at(word, index) == tile.char do
          {Tile.is_correct(tile), [tile.char | found]}
        else
          {tile, found}
        end
      end)

    # find all thats left
    {tiles, _} =
      Enum.map_reduce(tiles, found, fn tile, found ->
        cond do
          tile.state == :correct ->
            {tile, found}

          Enum.any?(word -- found, fn char -> char == tile.char end) ->
            {Tile.is_present(tile), [tile.char | found]}

          true ->
            {Tile.is_absent(tile), found}
        end
      end)

    tiles
  end
end
