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
      assert {:error, :invalid_word} = Row.check_row(row("flerp"), "swole")
    end

    test "should return an error if the word is not 5 letter" do
      assert {:error, :incomplete_word} = Row.check_row(row("fler"), "swole")
    end

    test "should return correct when the word is correct" do
      assert {:ok, :correct} = Row.check_row(row("swole"), "swole")
    end

    test "should return valid when the word is valid but not correct" do
      assert {:ok, :valid_word} = Row.check_row(row("wrist"), "swole")
    end
  end

  describe "update_row_state/2" do
    test "should set all tiles to absent when no letters match" do
      {:ok, row} = Row.update_row_state(row("click"), "start")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:absent, :absent, :absent, :absent, :absent]
    end

    test "should set tiles that are in the word but not in the correct spot to present" do
      {:ok, row} = Row.update_row_state(row("cramp"), "picks")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:present, :absent, :absent, :absent, :present]
    end

    test "should set tiles that are in the correct spot to correct" do
      {:ok, row} = Row.update_row_state(row("flame"), "blame")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:absent, :correct, :correct, :correct, :correct]
    end

    test "should not detect characters twice" do
      {:ok, row} = Row.update_row_state(row("hello"), "filet")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:absent, :present, :correct, :absent, :absent]
    end

    test "should not detect characters twice even if they are in the wrong spot" do
      {:ok, row} = Row.update_row_state(row("hello"), "livid")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:absent, :absent, :present, :absent, :absent]
    end

    test "it should find the letter twice if its in the word twice" do
      {:ok, row} = Row.update_row_state(row("alley"), "shell")

      result =
        row
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert result == [:absent, :present, :present, :present, :absent]
    end
  end
end
