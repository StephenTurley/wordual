defmodule Wordual.RowTest do
  use ExUnit.Case

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
      result =
        %Row{
          current_tile: 5,
          tiles: [
            Tile.for_char("a"),
            Tile.for_char("b"),
            Tile.for_char("c"),
            Tile.for_char("d"),
            Tile.for_char("e")
          ]
        }
        |> Row.add_char("f")

      assert result == {:error, :row_full}
    end
  end

  describe "clear_char/1" do
    test "it clears the current tile" do
      row = %Row{
        current_tile: 5,
        tiles: [
          Tile.for_char("a"),
          Tile.for_char("b"),
          Tile.for_char("c"),
          Tile.for_char("d"),
          Tile.for_char("e")
        ]
      }

      {:ok, result} = Row.clear_char(row)

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
      row = %Row{
        current_tile: 0,
        tiles: [Tile.init(), Tile.init(), Tile.init(), Tile.init(), Tile.init()]
      }

      assert {:error, :row_empty} = Row.clear_char(row)
    end
  end
end
