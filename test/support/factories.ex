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

  def board_with_words(board \\ Board.init(), words) when is_list(words) do
    {_, board} =
      Enum.map_reduce(words, board, fn word, board ->
        {:ok, board} =
          board
          |> board_with_word(word)
          # using abcde as the target word so i dont't match it on accident
          |> Board.submit_row("abcde")

        {word, board}
      end)

    board
  end

  def board_with_word(board \\ Board.init(), word) when is_binary(word) do
    word
    |> String.split("", trim: true)
    |> Enum.reduce(board, fn char, board ->
      {:ok, board} = Board.add_char(board, char)
      board
    end)
  end
end
