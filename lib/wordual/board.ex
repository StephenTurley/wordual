defmodule Wordual.Board do
  defstruct [:state, :rows, :current_row]
  alias Wordual.Row

  @max_row_index 3

  def init do
    %__MODULE__{
      state: :in_progress,
      current_row: 0,
      rows: Enum.map(0..@max_row_index, fn _ -> Row.init() end)
    }
  end

  def add_char(board, char) do
    update_row(board, &Row.add_char(&1, char))
  end

  def clear_char(board) do
    update_row(board, &Row.clear_char/1)
  end

  def submit_row(%{current_row: current_row, rows: rows} = board, word) do
    rows
    |> Enum.at(current_row)
    |> Row.check_row(word)
    |> case do
      {:ok, :correct} ->
        board
        |> Map.put(:state, :correct)
        |> update_row(&Row.update_row_state(&1, word))

      {:ok, :valid_word} ->
        board
        |> update_row(&Row.update_row_state(&1, word))
        |> increment_row()

      err ->
        err
    end
  end

  defp update_row(%{rows: rows, current_row: current_row} = board, updater) do
    rows
    |> Enum.at(current_row)
    |> updater.()
    |> case do
      {:ok, row} ->
        {:ok,
         Map.merge(board, %{
           current_row: current_row,
           rows: List.replace_at(rows, current_row, row)
         })}

      err ->
        err
    end
  end

  # out of rows
  defp increment_row({:ok, %{current_row: @max_row_index} = board}) do
    {:ok, Map.put(board, :state, :failed)}
  end

  defp increment_row({:ok, board}) do
    {:ok,
     Map.update!(board, :current_row, fn current_row ->
       current_row + 1
     end)}
  end
end
