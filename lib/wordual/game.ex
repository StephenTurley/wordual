defmodule Wordual.Game do
  defstruct [:id, :state, :word, boards: %{}]

  alias Wordual.Board

  def init(id, word) do
    %__MODULE__{id: id, word: word, state: :starting}
  end

  def add_char(%{state: :in_progress} = game, player_id, char) do
    row =
      game.boards[player_id]
      |> List.first()
      |> List.replace_at(0, %{char: char})

    board =
      game.boards[player_id]
      |> List.replace_at(0, row)

    boards = Map.put(game.boards, player_id, board)
    game = Map.put(game, :boards, boards)

    {:ok, game}
  end

  def add_char(_game, _player_id, _char) do
    {:error, :not_started}
  end

  def join(game, player_id) do
    cond do
      Map.has_key?(game.boards, player_id) ->
        game

      map_size(game.boards) == 2 ->
        game

      map_size(game.boards) == 1 ->
        game
        |> Map.put(:boards, init_player(game.boards, player_id))
        |> Map.put(:state, :in_progress)

      true ->
        Map.put(game, :boards, init_player(game.boards, player_id))
    end
  end

  def other_player(game, player_id) do
    Map.keys(game.boards)
    |> Enum.reject(&(&1 == player_id))
    |> List.first()
  end

  defp init_player(boards, player_id) do
    Map.put(boards, player_id, Board.init())
  end
end
