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

  describe "is_present/1" do
    test "should update the tile to present" do
      %Tile{state: state, char: char} = Tile.for_char("b") |> Tile.is_present()

      assert state == :present
      assert char == "b"
    end
  end

  describe "is_absent/1" do
    test "should update the tile to absent" do
      %Tile{state: state, char: char} = Tile.for_char("b") |> Tile.is_absent()

      assert state == :absent
      assert char == "b"
    end
  end

  describe "is_correct/1" do
    test "should update the tile to correct" do
      %Tile{state: state, char: char} = Tile.for_char("b") |> Tile.is_correct()

      assert state == :correct
      assert char == "b"
    end
  end
end
