defmodule Wordual.Game do
  defstruct [:id, :state, :word, boards: %{}]

  alias Wordual.Board

  def init(id, word) do
    %__MODULE__{id: id, word: word, state: :starting}
  end

  def add_char(%{state: :in_progress} = game, player_id, char) do
    update_board(game, player_id, &Board.add_char(&1, char))
  end

  def add_char(%{state: :complete}, _player_id, _char), do: {:error, :game_complete}

  def add_char(_game, _player_id, _char), do: {:error, :not_started}

  def clear_char(%{state: :in_progress} = game, player_id) do
    update_board(game, player_id, &Board.clear_char/1)
  end

  def clear_char(%{state: :complete}, _player_id), do: {:error, :game_complete}

  def clear_char(_game, _player_id), do: {:error, :not_started}

  def join(game, player_id) do
    cond do
      Map.has_key?(game.boards, player_id) ->
        game

      map_size(game.boards) == 2 ->
        game

      map_size(game.boards) == 1 ->
        game
        |> Map.put(:boards, init_board(game.boards, player_id))
        |> Map.put(:state, :in_progress)

      true ->
        Map.put(game, :boards, init_board(game.boards, player_id))
    end
  end

  # TODO test me
  def submit_row(%{state: :complete}, _player_id), do: {:error, :game_complete}

  def submit_row(game, player_id) do
    update_board(game, player_id, &Board.submit_row(&1, game.word))
  end

  def other_player(game, player_id) do
    Map.keys(game.boards)
    |> Enum.reject(&(&1 == player_id))
    |> List.first()
  end

  defp init_board(boards, player_id) do
    Map.put(boards, player_id, Board.init())
  end

  defp update_board(game, player_id, updater) do
    game.boards[player_id]
    |> updater.()
    |> case do
      {:ok, %{state: :in_progress} = board} ->
        {:ok, replace_board(game, player_id, board)}

      # correct or failed == game over
      {:ok, board} ->
        game =
          game
          |> replace_board(player_id, board)
          |> Map.put(:state, :complete)

        {:ok, game}

      err ->
        err
    end
  end

  defp replace_board(game, player_id, board) do
    Map.replace!(game, :boards, Map.replace!(game.boards, player_id, board))
  end
end
