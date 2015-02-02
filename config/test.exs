use Mix.Config

config :cedar, Cedar.Endpoint,
  http: [port: System.get_env("PORT") || 4001]


config :logger, level: :warn

config :database, location: "test_db"
