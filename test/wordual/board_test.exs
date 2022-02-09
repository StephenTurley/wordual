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

  describe "submit_row/2" do
    test "it should set the state to correct when the row is correct" do
      {:ok, %{state: :correct, rows: rows}} = Board.submit_row(board("swole"), "swole")

      rows
      |> List.first()
      |> is_correct_row()
    end

    test "it should return error if the row is not a valid word" do
      assert {:error, :invalid_word} == Board.submit_row(board("flerp"), "swole")
    end

    test "it should update row state and current_row if the word is valid but not correct" do
      {:ok, board} = Board.submit_row(board("blame"), "swole")

      assert board.state == :in_progress
      assert board.current_row == 1

      tile_states =
        board.rows
        |> Enum.at(0)
        |> Map.get(:tiles)
        |> Enum.map(&Map.get(&1, :state))

      assert tile_states == [:absent, :present, :absent, :absent, :correct]
    end
  end
end
