defmodule Wordual.KeyboardHintsTest do
  use ExUnit.Case

  alias Wordual.KeyboardHints
  alias Wordual.Tile

  test "it should return nil when there is not hint" do
    assert nil ==
             KeyboardHints.init()
             |> KeyboardHints.for("a")
  end

  test "it should return an absent state" do
    tile =
      Tile.for_char("a")
      |> Tile.is_absent()

    assert :absent ==
             KeyboardHints.init()
             |> KeyboardHints.update(tile)
             |> KeyboardHints.for("a")
  end

  test "it should return an present state" do
    tile =
      Tile.for_char("b")
      |> Tile.is_present()

    assert :present ==
             KeyboardHints.init()
             |> KeyboardHints.update(tile)
             |> KeyboardHints.for("b")
  end

  test "it should update present to correct" do
    present =
      Tile.for_char("b")
      |> Tile.is_present()

    correct = Tile.is_correct(present)

    assert :correct ==
             KeyboardHints.init()
             |> KeyboardHints.update(present)
             |> KeyboardHints.update(correct)
             |> KeyboardHints.for("b")
  end

  test "it should not update correct to present" do
    present =
      Tile.for_char("b")
      |> Tile.is_present()

    correct = Tile.is_correct(present)

    assert :correct ==
             KeyboardHints.init()
             |> KeyboardHints.update(correct)
             |> KeyboardHints.update(present)
             |> KeyboardHints.for("b")
  end

  test "it should not update present to absent" do
    present =
      Tile.for_char("b")
      |> Tile.is_present()

    absent = Tile.is_absent(present)

    assert :present ==
             KeyboardHints.init()
             |> KeyboardHints.update(present)
             |> KeyboardHints.update(absent)
             |> KeyboardHints.for("b")
  end
end
