defmodule WordualWeb.GameLive do
  use WordualWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, _pid, game_id} = Wordual.start_game()
    {:ok, assign(socket, :game_id, game_id)}
  end
end
