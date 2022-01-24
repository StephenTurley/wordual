defmodule WordualWeb.PageController do
  use WordualWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
