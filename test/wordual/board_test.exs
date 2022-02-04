defmodule Wordual.BoardTest do
  use ExUnit.Case
  alias Wordual.Board
  alias Wordual.Row
  alias Wordual.Tile

  describe "init/0" do
    test "should intitialize the empty board" do
      result = Board.init()

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
  end
end
