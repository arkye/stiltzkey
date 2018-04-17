# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stiltzkey,
  ecto_repos: [Stiltzkey.Repo]

# Configures the endpoint
config :stiltzkey, StiltzkeyWeb.Endpoint,
  url: [host: System.get_env("HOSTNAME"), port: System.get_env("PORT")],
  http: [port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: StiltzkeyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stiltzkey.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures i18n
config :stiltzkey, StiltzkeyWeb.Gettext,
  default_locale: "pt",
  locales: ~w(en pt)

# Configures database
config :stiltzkey, Stiltzkey.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DATABASE"),
  hostname: System.get_env("POSTGRES_HOSTNAME")

# Configure Guardian Authentication
config :stiltzkey, StiltzkeyWeb.Helpers.Auth.Guardian,
  issuer: "stiltzkey",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  ttl: {1, :days}

config :stiltzkey, StiltzkeyWeb.Helpers.Auth.AccessPipeline,
  module: StiltzkeyWeb.Helpers.Auth.Guardian,
  error_handler: StiltzkeyWeb.Helpers.Auth.NoErrorHandler

config :stiltzkey, StiltzkeyWeb.Helpers.Auth.EnsureAccessPipeline,
  module: StiltzkeyWeb.Helpers.Auth.Guardian,
  error_handler: StiltzkeyWeb.Helpers.Auth.ErrorHandler

# Configure Cipher Hashing
config :cipher, runtime_phrases: true,
  keyphrase: System.get_env("CIPHER_KEYPHRASE"),
  ivphrase: System.get_env("CIPHER_IVPHRASE"),
  magic_token: System.get_env("CIPHER_MAGIC_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
