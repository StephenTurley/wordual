defmodule Wordual.Board do
  defstruct [:rows, :current_row]
  alias Wordual.Row

  def init() do
    %__MODULE__{
      current_row: 0,
      rows: Enum.map(0..4, fn _ -> Row.init() end)
    }
  end

  def add_char(%{rows: rows, current_row: current_row}, char) do
    rows
    |> Enum.at(current_row)
    |> Row.add_char(char)
    |> case do
      {:ok, row} ->
        {:ok,
         %__MODULE__{
           current_row: current_row,
           rows: List.replace_at(rows, current_row, row)
         }}

      err ->
        err
    end
  end
end
