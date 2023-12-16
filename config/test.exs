import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wordual, WordualWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gp2LEeUGoNUhJlf8FFdOPxGduNWLhYs3joA+5czWVtCklZKuV7r9RQ0lqKn4AvVg",
  server: false

# In test we don't send emails.
config :wordual, Wordual.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
