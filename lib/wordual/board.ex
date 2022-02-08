defmodule Wordual.Board do
  defstruct [:state, :rows, :current_row]
  alias Wordual.Row

  def init() do
    %__MODULE__{
      state: :in_progress,
      current_row: 0,
      rows: Enum.map(0..5, fn _ -> Row.init() end)
    }
  end

  def add_char(row, char) do
    update_row(row, &Row.add_char(&1, char))
  end

  def clear_char(row) do
    update_row(row, &Row.clear_char/1)
  end

  defp update_row(%{rows: rows, current_row: current_row} = game, updater) do
    rows
    |> Enum.at(current_row)
    |> updater.()
    |> case do
      {:ok, row} ->
        {:ok,
         Map.merge(game, %{
           current_row: current_row,
           rows: List.replace_at(rows, current_row, row)
         })}

      err ->
        err
    end
  end
end
