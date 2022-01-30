defmodule WordualWeb.GameLive do
  use WordualWeb, :live_view
  require Logger

  @impl true
  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      {:ok, game} = Wordual.join_game(game_id, player_id)
      {:ok, assigns(socket, game, player_id)}
    else
      {:ok, assign(socket, :game, nil)}
    end
  end

  @impl true
  def mount(_params, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      {:ok, game} = Wordual.start_game(player_id)
      {:ok, assigns(socket, game, player_id)}
    else
      {:ok, assign(socket, :game, nil)}
    end
  end

  defp assigns(socket, game, player_id) do
    socket
    |> assign(:game, game)
    |> assign(:this_player, player_id)
  end

  @impl true
  def handle_info({:player_joined, player_id, game_id}, socket) do
    Logger.info("Player: #{player_id} joined game: #{game_id}")
    {:ok, game} = Wordual.get_game(game_id)

    {:noreply, assign(socket, :game, game)}
  end
end
