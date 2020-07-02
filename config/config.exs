# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exawesome,
  ecto_repos: [Exawesome.Repo]

# Configures the endpoint
config :exawesome, ExawesomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MjqWrPlYQEF1th8Mk29juYNdop+CbN24uSYvb2Lty2/ZDXFy3/yj4G41hgJFwOHf",
  render_errors: [view: ExawesomeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exawesome.PubSub,
  live_view: [signing_salt: "gdYUEEuu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
