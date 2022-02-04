defmodule Wordual.TileTest do
  use ExUnit.Case

  alias Wordual.Tile

  describe "init/0" do
    test "it should create a tile" do
      result = Tile.init()
      assert result == %Tile{state: :empty, char: nil}
    end
  end
end
