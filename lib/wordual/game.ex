defmodule Wordual.Game do
  defstruct [:id, :state, :word, players: %{}]

  def init(id, word) do
    %__MODULE__{id: id, word: word, state: :starting}
  end

  def add_char(%{state: :in_progress} = game, player_id, char) do
    row =
      game.players[player_id]
      |> List.first()
      |> List.replace_at(0, %{char: char})

    board =
      game.players[player_id]
      |> List.replace_at(0, row)

    players = Map.put(game.players, player_id, board)
    game = Map.put(game, :players, players)

    {:ok, game}
  end

  def add_char(_game, _player_id, _char) do
    {:error, :not_started}
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
