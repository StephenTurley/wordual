defmodule Wordual.GameTest do
  use ExUnit.Case

  import Wordual.Test.Support.Assertions

  alias Wordual.Game
  alias Wordual.Row

  describe "init/2" do
    test "it starts in the :starting state" do
      result = Game.init("abc123", "swole")
      assert result.id == "abc123"
      assert result.word == "swole"
      assert result.state == :starting
      assert result.boards == %{}
    end
  end

  describe "add_char/3" do
    test "it should return an error if the game has not started" do
      assert {:error, :not_started} ==
               Game.init("abc123", "swole")
               |> Game.join("flerpn1")
               |> Game.add_char("flerpn1", "a")
    end

    test "it should add a letter to the current row" do
      {:ok, result} =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.add_char("flerpn1", "a")

      first_row =
        result.boards
        |> Map.get("flerpn1")
        |> Map.get(:rows)
        |> List.first()

      assert {:ok, first_row} == Row.add_char(Row.init(), "a")
    end

    test "it returns an error when the row is full" do
      game =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")

      {_, game} =
        Enum.map_reduce(1..5, game, fn i, game ->
          {:ok, game} = Game.add_char(game, "flerpn1", "a")
          {i, game}
        end)

      assert {:error, :row_full} == Game.add_char(game, "flerpn1", "a")
    end
  end

  describe "clear_char/2" do
    test "it should return an error if the game has not started" do
      assert {:error, :not_started} ==
               Game.init("abc123", "swole")
               |> Game.join("flerpn1")
               |> Game.clear_char("flerpn1")
    end

    test "it should return an error when the row is empty" do
      assert {:error, :row_empty} ==
               Game.init("abc123", "flerp")
               |> Game.join("flerpn1")
               |> Game.join("flerpn2")
               |> Game.clear_char("flerpn1")
    end

    test "it should clear the char" do
      {:ok, game} =
        Game.init("abc123", "flerp")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.add_char("flerpn1", "a")

      {:ok, game} = Game.clear_char(game, "flerpn1")

      game
      |> Map.get(:boards)
      |> Map.get("flerpn1")
      |> is_initiailzied_board()
    end
  end

  describe "join/2" do
    test "It initializes the board for the players" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")

      result.boards
      |> Map.get("flerpn1")
      |> is_initiailzied_board()

      result.boards
      |> Map.get("flerpn2")
      |> is_initiailzied_board()
    end

    test "It only allows the player to join once" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn1")

      assert Map.keys(result.boards) == ["flerpn1"]
    end

    test "It doesn't allow a 3rd person to join" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.join("flerpn3")

      assert Map.keys(result.boards) == ["flerpn1", "flerpn2"]
    end

    test "It changes the state to :in_progress once both players have joined" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")

      assert result.state == :starting

      result = Game.join(result, "flerpn2")

      assert result.state == :in_progress
    end
  end
end
