# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :katenhond,
  ecto_repos: [Katenhond.Repo]

config :katenhond_web,
  ecto_repos: [Katenhond.Repo],
  generators: [context_app: :katenhond]

# Configures the endpoint
config :katenhond_web, KatenhondWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3MdbMx+v2BmfdGeWUUokn9WQSFdmt0wKWQwKtx8umKo59Kj1x8IhSLTEoTEx3F30",
  render_errors: [view: KatenhondWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KatenhondWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Bov+vjBL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
