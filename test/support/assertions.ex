defmodule Wordual.Test.Support.Assertions do
  import ExUnit.Assertions

  alias Wordual.Row
  alias Wordual.Tile

  def is_initiailzied_board(result) do
    assert result.current_row == 0

    Enum.each(result.rows, fn row ->
      assert row == %Row{
               current_tile: 0,
               tiles: [
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil},
                 %Tile{state: :empty, char: nil}
               ]
             }
    end)
  end
end
