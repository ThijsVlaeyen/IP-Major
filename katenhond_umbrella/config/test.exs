use Mix.Config

# Configure your database
config :katenhond, Katenhond.Repo,
  username: "root",
  password: "root",
  database: "katenhond_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :katenhond_web, KatenhondWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
