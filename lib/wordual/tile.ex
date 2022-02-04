defmodule Wordual.Tile do
  defstruct [:state, :char]

  def init() do
    %__MODULE__{state: :empty}
  end
end
