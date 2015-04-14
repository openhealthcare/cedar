use Mix.Config

config :cedar, Cedar.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  cache_static_lookup: false,
  external_actions: false

# Enables code reloading for development
config :cedar, Cedar.Endpoint,
  code_reloader: true,
  live_reload: [
    patterns: [~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
               ~r{web/views/.*(ex)$},
               ~r{web/templates/.*(eex)$}]]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

