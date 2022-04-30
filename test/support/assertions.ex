defmodule Wordual.Test.Support.Assertions do
  import ExUnit.Assertions

  alias Wordual.Row
  alias Wordual.Tile

  def is_initialized_board(result) do
    assert result.state == :in_progress
    assert result.current_row == 0

    Enum.each(result.rows, fn row ->
      assert row == %Row{
               current_tile: 0,
               tiles: [
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil}
               ]
             }
    end)
  end

  def is_correct_row(row) do
    Enum.each(row.tiles, fn tile ->
      assert :correct == tile.state
    end)
  end
end
