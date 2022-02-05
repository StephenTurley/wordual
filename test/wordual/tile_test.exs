defmodule Wordual.TileTest do
  use ExUnit.Case

  alias Wordual.Tile

  describe "init/0" do
    test "it should create a tile" do
      result = Tile.init()
      assert result == %Tile{state: :empty, char: nil}
    end
  end

  describe "for_char/1" do
    test "should create a tile with the char" do
      %Tile{state: state, char: char} = Tile.for_char("b")

      assert state == :filled
      assert char == "b"
    end
  end
end
