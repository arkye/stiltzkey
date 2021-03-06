use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stiltzkey, StiltzkeyWeb.Endpoint,
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stiltzkey, Stiltzkey.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Comeonin Hashing
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
