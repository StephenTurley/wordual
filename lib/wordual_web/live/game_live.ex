defmodule WordualWeb.GameLive do
  use WordualWeb, :live_view

  @impl true
  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      case Wordual.join_game(game_id, player_id) do
        {:ok, game} ->
          {:ok, assign(socket, :game, game)}

        {:error, :game_full} ->
          {:ok, game} = Wordual.start_game(player_id)
          {:ok, assign(socket, :game, game)}
      end
    else
      {:ok, assign(socket, :game, nil)}
    end
  end

  @impl true
  def mount(_params, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      {:ok, game} = Wordual.start_game(player_id)
      {:ok, assign(socket, :game, game)}
    else
      {:ok, assign(socket, :game, nil)}
    end
  end
end
