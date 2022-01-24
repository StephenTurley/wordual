defmodule Wordual.Repo do
  use Ecto.Repo,
    otp_app: :wordual,
    adapter: Ecto.Adapters.Postgres
end
