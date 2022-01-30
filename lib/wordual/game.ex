defmodule Wordual.Game do
  defstruct [:id, :word, player_1: %{id: nil, board: nil}, player_2: %{id: nil, board: nil}]

  def init(id, word) do
    %__MODULE__{id: id, word: word}
  end

  def join(game, player_id) do
    cond do
      game.player_1.id == nil ->
        init_player(game, player_id, :player_1)

      game.player_1.id == player_id ->
        game

      game.player_2.id == nil ->
        init_player(game, player_id, :player_2)

      true ->
        game
    end
  end

  defp init_player(game, player_id, player) do
    Map.put(game, player, %{id: player_id, board: init_board()})
  end

  defp init_board() do
    [
      [%{}, %{}, %{}, %{}, %{}],
      [%{}, %{}, %{}, %{}, %{}],
      [%{}, %{}, %{}, %{}, %{}],
      [%{}, %{}, %{}, %{}, %{}],
      [%{}, %{}, %{}, %{}, %{}]
    ]
  end
end
