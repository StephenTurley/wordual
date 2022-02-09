defmodule Wordual.Test.Support.Factories do
  alias Wordual.Row
  alias Wordual.Board

  def row(word) do
    word
    |> String.split("", trim: true)
    |> Enum.reduce(Row.init(), fn char, row ->
      {:ok, row} = Row.add_char(row, char)
      row
    end)
  end

  def board(word) do
    word
    |> String.split("", trim: true)
    |> Enum.reduce(Board.init(), fn char, board ->
      {:ok, board} = Board.add_char(board, char)
      board
    end)
  end
end
