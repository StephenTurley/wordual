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

  describe "add_char/2" do
    test "it adds a char to the row and increments current_tile" do
      {:ok, result} =
        Row.init()
        |> Row.add_char("a")

      assert result.current_tile == 1

      assert result.tiles == [
               %Tile{state: :filled, char: "a"},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil}
             ]

      {:ok, result} = Row.add_char(result, "b")
      assert result.current_tile == 2

      assert result.tiles == [
               %Tile{state: :filled, char: "a"},
               %Tile{state: :filled, char: "b"},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil},
               %Tile{state: :empty, char: nil}
             ]
    end

    test "it returns an error when the row is full" do
      result =
        %Row{
          current_tile: 5,
          tiles: [
            %Tile{state: :filled, char: "a"},
            %Tile{state: :filled, char: "b"},
            %Tile{state: :filled, char: "c"},
            %Tile{state: :filled, char: "d"},
            %Tile{state: :filled, char: "e"}
          ]
        }
        |> Row.add_char("f")

      assert result == {:error, :row_full}
    end
  end

  describe "clear_char/1" do
    test "it clears the current tile" do
      row = %Row{
        current_tile: 5,
        tiles: [
          %Tile{state: :filled, char: "a"},
          %Tile{state: :filled, char: "b"},
          %Tile{state: :filled, char: "c"},
          %Tile{state: :filled, char: "d"},
          %Tile{state: :filled, char: "e"}
        ]
      }

      {:ok, result} = Row.clear_char(row)

      assert result.current_tile == 4

      assert result.tiles == [
               %Tile{state: :filled, char: "a"},
               %Tile{state: :filled, char: "b"},
               %Tile{state: :filled, char: "c"},
               %Tile{state: :filled, char: "d"},
               %Tile{state: :empty, char: nil}
             ]
    end

    test "it returns an error when the row is empty" do
      row = %Row{
        current_tile: 0,
        tiles: [
          %Tile{state: :empty, char: nil},
          %Tile{state: :empty, char: nil},
          %Tile{state: :empty, char: nil},
          %Tile{state: :empty, char: nil},
          %Tile{state: :empty, char: nil}
        ]
      }

      assert {:error, :row_empty} = Row.clear_char(row)
    end
  end
end
