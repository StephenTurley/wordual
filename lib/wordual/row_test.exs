defmodule Wordual.RowTest do
  use ExUnit.Case
  import Wordual.Test.Support.Factories

  alias Wordual.Row
  alias Wordual.Tile

  describe "init/0" do
    test "it creates a row" do
      result = Row.init()
      assert result.current_tile == 0

      assert result.tiles == [Tile.init(), Tile.init(), Tile.init(), Tile.init(), Tile.init()]
    end
  end

  describe "add_char/2" do
    test "it adds a char to the row and increments current_tile" do
      {:ok, result} =
        Row.init()
        |> Row.add_char("a")

      assert result.current_tile == 1

      assert result.tiles == [
               Tile.for_char("a"),
               Tile.init(),
               Tile.init(),
               Tile.init(),
               Tile.init()
             ]

      {:ok, result} = Row.add_char(result, "b")
      assert result.current_tile == 2

      assert result.tiles == [
               Tile.for_char("a"),
               Tile.for_char("b"),
               Tile.init(),
               Tile.init(),
               Tile.init()
             ]
    end

    test "it returns an error when the row is full" do
      result = Row.add_char(row("flerp"), "n")

      assert result == {:error, :row_full}
    end
  end

  describe "clear_char/1" do
    test "it clears the current tile" do
      {:ok, result} = Row.clear_char(row("abcde"))

      assert result.current_tile == 4

      assert result.tiles == [
               Tile.for_char("a"),
               Tile.for_char("b"),
               Tile.for_char("c"),
               Tile.for_char("d"),
               Tile.init()
             ]
    end

    test "it returns an error when the row is empty" do
      assert {:error, :row_empty} = Row.clear_char(Row.init())
    end
  end

  describe "check_row/2" do
    test "should return an error when the word is invalid" do
    end
  end
end
