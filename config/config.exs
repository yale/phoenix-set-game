# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :set_game,
  ecto_repos: [SetGame.Repo]

# Configures the endpoint
config :set_game, SetGameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M4zdsJrKhGi40E4hsQUv4cx4yW+Udw+LXx9kF6+wKiiNdqFdg326lv42svEJbT90",
  render_errors: [view: SetGameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SetGame.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
