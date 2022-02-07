defmodule Wordual.Test.Support.Factories do
  alias Wordual.Row

  def row(word) do
    word
    |> String.split("", trim: true)
    |> Enum.reduce(Row.init(), fn char, row ->
      {:ok, row} = Row.add_char(row, char)
      row
    end)
  end
end
