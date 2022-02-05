defmodule Wordual.Tile do
  defstruct [:state, :char]

  def init() do
    %__MODULE__{state: :empty}
  end

  def for_char(char) do
    %__MODULE__{state: :filled, char: char}
  end
end
