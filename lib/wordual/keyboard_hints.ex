defmodule Wordual.KeyboardHints do
  defstruct []

  def init() do
    %__MODULE__{}
  end

  def for(hints, char) do
    Map.get(hints, char)
  end

  def update(hints, tile) do
    Map.update(hints, tile.char, tile.state, fn state ->
      maybe_update(state, tile)
    end)
  end

  defp maybe_update(:absent, tile), do: tile.state
  defp maybe_update(:correct, _), do: :correct
  defp maybe_update(:present, %{state: :correct}), do: :correct
  defp maybe_update(:present, _), do: :present
  defp maybe_update(_, tile), do: tile.state
end
