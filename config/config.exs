# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :siano,
  ecto_repos: [Siano.Repo]

# Configures the endpoint
config :siano, SianoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EgT3NuB5vI1X7/GVaBru/GzP3yVduNHGJQC1eLVd2Voog1WEaFxpmRxUBNLXRD/s",
  render_errors: [view: SianoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Siano.PubSub, adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  user_context: Siano.Accounts,
  crypto_module: Bcrypt,
  token_module: SianoWeb.Auth.Token

# Mailer configuration
config :siano, SianoWeb.Mailer,
  adapter: Bamboo.LocalAdapter

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :bamboo, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
