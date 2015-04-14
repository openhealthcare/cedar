use Mix.Config

config :cedar, Cedar.Endpoint,
  http: [port: System.get_env("PORT") || 4001],
  external_actions: false

config :logger, level: :warn

config :cedar, Cedar.Repo,
   adapter: Ecto.Adapters.Postgres,
   username: "cedar",
   password: "password",
   database: "cedar"