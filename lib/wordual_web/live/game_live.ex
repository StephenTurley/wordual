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
  def handle_info({:game_updated, player_id, game_id}, socket) do
    Logger.info("Player: #{player_id} updated game: #{game_id}")
    {:ok, game} = Wordual.get_game(game_id)

    {:noreply, assign(socket, :game, game)}
  end

  @impl true
  def handle_event("add_char", %{"key" => key}, socket) do
    with true <- valid_key?(key),
         player_id <- socket.assigns.this_player,
         {:ok, game} <-
           socket.assigns
           |> Map.get(:game)
           |> Map.get(:id)
           |> Wordual.add_char(player_id, key) do
      Logger.info("Player #{player_id} pressed key: #{key}")
      {:noreply, assign(clear_flash(socket), :game, game)}
    else
      {:error, :row_full} ->
        socket = put_flash(socket, :error, "The row is full")
        {:noreply, socket}

      {:error, :not_started} ->
        socket = put_flash(socket, :error, "Waiting for the other player")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  defp valid_key?(key) do
    String.length(key) == 1 && String.match?(key, ~r/[a-z]/)
  end
end
