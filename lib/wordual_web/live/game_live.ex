defmodule WordualWeb.GameLive do
  use WordualWeb, :live_view

  @impl true
  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      case Wordual.join_game(game_id, player_id) do
        {:ok, game} ->
          {:ok, assigns(socket, game, player_id)}

        _ ->
          {:ok, game} = Wordual.start_game(player_id)
          {:ok, assigns(socket, game, player_id)}
      end
    else
      {:ok, assign(socket, :game, nil)}
    end
  end

  @impl true
  def mount(_params, %{"player_id" => player_id}, socket) do
    if connected?(socket) do
      {:ok, game} = Wordual.start_game(player_id)

      socket =
        socket
        |> assigns(game, player_id)
        |> push_redirect(to: "/#{game.id}")

      {:ok, socket}
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
  def handle_info({:game_updated, _player_id, game_id}, socket) do
    {:ok, game} = Wordual.get_game(game_id)

    {:noreply, assign(socket, :game, game)}
  end

  @impl true
  def handle_event("new_game", _, socket) do
    player_id = socket.assigns.this_player

    {:ok, game} =
      socket.assigns.game.id
      |> Wordual.restart_game(player_id)

    {:noreply, assign(socket, :game, game)}
  end

  @impl true
  def handle_event("key_down", %{"key" => key}, socket) do
    with {:ok, action} <- action(key),
         player_id <- socket.assigns.this_player,
         {:ok, game} <-
           socket.assigns
           |> Map.get(:game)
           |> Map.get(:id)
           |> action.(player_id) do
      {:noreply, assign(clear_flash(socket), :game, game)}
    else
      {:error, :not_started} ->
        socket = put_flash(socket, :error, "Waiting for the other player")
        {:noreply, socket}

      {:error, :game_complete} ->
        socket = put_flash(socket, :info, "Game over")
        {:noreply, socket}

      {:error, :invalid_word} ->
        socket = put_flash(socket, :info, "Not a known word")
        {:noreply, socket}

      {:error, :not_found} ->
        socket = put_flash(socket, :error, "Game timed out. Refresh to play again.")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def valid_char?(key) do
    String.length(key) == 1 && String.match?(key, ~r/[a-zA-Z]/)
  end

  defp action(key) do
    cond do
      key == "Backspace" ->
        {:ok, &Wordual.clear_char/2}

      key == "Enter" ->
        {:ok, &Wordual.submit_row/2}

      valid_char?(key) ->
        {:ok, &Wordual.add_char(&1, &2, key)}

      true ->
        {:error, :invalid_key}
    end
  end
end
