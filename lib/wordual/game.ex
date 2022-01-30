defmodule Wordual.Game do
  defstruct [:id, :state, :word, players: %{}]

  def init(id, word) do
    %__MODULE__{id: id, word: word, state: :starting}
  end

  def join(game, player_id) do
    cond do
      Map.has_key?(game.players, player_id) ->
        game

      map_size(game.players) == 2 ->
        game

      map_size(game.players) == 1 ->
        game
        |> Map.put(:players, init_player(game.players, player_id))
        |> Map.put(:state, :in_progress)

      true ->
        Map.put(game, :players, init_player(game.players, player_id))
    end
  end

  def other_player(game, player_id) do
    Map.keys(game.players)
    |> Enum.reject(&(&1 == player_id))
    |> List.first()
  end

  defp init_player(players, player_id) do
    Map.put(players, player_id, init_board())
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
