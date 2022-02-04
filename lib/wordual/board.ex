defmodule Wordual.Board do
  defstruct [:rows, :current_row]
  alias Wordual.Row

  def init() do
    %__MODULE__{
      current_row: 0,
      rows: Enum.map(0..4, fn _ -> Row.init() end)
    }
  end
end
