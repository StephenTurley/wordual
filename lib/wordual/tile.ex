defmodule Wordual.Tile do
  defstruct [:state, :char]

  def init() do
    %__MODULE__{state: :empty}
  end

  def for_char(char) do
    %__MODULE__{state: :filled, char: char}
  end

  def is_present(tile) do
    Map.put(tile, :state, :present)
  end

  def is_absent(tile) do
    Map.put(tile, :state, :absent)
  end

  def is_correct(tile) do
    Map.put(tile, :state, :correct)
  end
end
