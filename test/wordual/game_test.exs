defmodule Wordual.GameTest do
  use ExUnit.Case

  alias Wordual.Game

  describe "init/2" do
    test "it starts in the :starting state" do
      result = Game.init("abc123", "swole")
      assert result.id == "abc123"
      assert result.word == "swole"
      assert result.state == :starting
      assert result.players == %{}
    end
  end

  describe "join/2" do
    test "It initializes the board for the players" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")

      assert Map.get(result.players, "flerpn1") == [
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}]
             ]

      assert Map.get(result.players, "flerpn2") == [
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}],
               [%{}, %{}, %{}, %{}, %{}]
             ]
    end

    test "It only allows the player to join once" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn1")

      assert Map.keys(result.players) == ["flerpn1"]
    end

    test "It doesn't allow a 3rd person to join" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.join("flerpn3")

      assert Map.keys(result.players) == ["flerpn1", "flerpn2"]
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
