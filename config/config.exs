# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :metapede,
  ecto_repos: [Metapede.Repo]

# Configures the endpoint
config :metapede, MetapedeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vmttvhQ5dAfooD1zK/UEMDYWfT6i0ASNxLGH6azK63c6NZOWCcjVTevTKNv00tt2",
  render_errors: [view: MetapedeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Metapede.PubSub,
  live_view: [signing_salt: "ZYeV/D/L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
