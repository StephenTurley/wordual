defmodule Wordual.Game do
  defstruct [:id, :word, players: %{}]

  def init(id, word) do
    %__MODULE__{id: id, word: word}
  end

  def join(game, player_id) do
    cond do
      map_size(game.players) == 2 ->
        game

      Map.has_key?(game.players, player_id) ->
        game

      true ->
        Map.put(game, :players, init_player(game.players, player_id))
    end
  end

  def other_player(game, player_id) do
    Map.keys(game.players)
    |> IO.inspect(label: "keys")
    |> Enum.reject(&(&1 == player_id))
    |> IO.inspect(label: "rejected")
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
