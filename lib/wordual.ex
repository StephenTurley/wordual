defmodule Wordual do
  @moduledoc """
  Wordual keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Wordual.Game

  def start_game do
    id = Ecto.UUID.generate()
    {:ok, pid} = Game.start(id)
    {:ok, pid, id}
  end
end
