defmodule Wordual.RowTest do
  use ExUnit.Case

  alias Wordual.Row
  alias Wordual.Tile

  describe "init/0" do
    test "it creates a row" do
      result = Row.init()
      assert result.current_tile == 0

      assert result.tiles == [
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil}
             ]
    end
  end
end
