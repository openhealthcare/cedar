# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cedar, Cedar.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dywFWz8XZvQwGDVA6MA4bllVBBPqtZE8psfnf+7PSCxOsC4sCigQ5/rriKCUfkVR",
  debug_errors: false,
  server: true,
  pubsub: [adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :database, location: "cedar_db"

config :auditor, location: "logs/"

config :cedar, mailgun_domain: "sandbox2f06dae5c6c840b9824a8160a83e0e72.mailgun.org",
               mailgun_key: System.get_env("MAILGUN_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
