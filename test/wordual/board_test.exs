defmodule Wordual.BoardTest do
  use ExUnit.Case
  import Wordual.Test.Support.Assertions
  import Wordual.Test.Support.Factories

  alias Wordual.Board
  alias Wordual.Row
  alias Wordual.Tile

  describe "init/0" do
    test "should intitialize the empty board" do
      is_initiailzied_board(Board.init())
    end
  end

  describe "add_char/2" do
    test "should add a character" do
      {:ok, %{rows: [first_row | _], current_row: 0}} = Board.add_char(Board.init(), "a")

      assert first_row == row("a")
    end

    test "should return an error when row is full" do
      result =
        Board.add_char(
          %Board{
            current_row: 0,
            rows: [row("flerp"), Row.init(), Row.init(), Row.init(), Row.init()]
          },
          "a"
        )

      assert result == {:error, :row_full}
    end
  end

  describe "clear_char/2" do
    test "it should remove the char" do
      {:ok, %{rows: [first_row | _], current_row: 0}} =
        Board.clear_char(%Board{
          current_row: 0,
          rows: [row("flerp"), Row.init(), Row.init(), Row.init(), Row.init()]
        })

      assert first_row.tiles == [
               Tile.for_char("f"),
               Tile.for_char("l"),
               Tile.for_char("e"),
               Tile.for_char("r"),
               Tile.init()
             ]
    end

    test "it should return an error when the row is empty" do
      assert {:error, :row_empty} == Board.clear_char(Board.init())
    end
  end
end
