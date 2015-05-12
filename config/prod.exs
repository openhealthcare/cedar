use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :cedar, Cedar.Endpoint,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "dywFWz8XZvQwGDVA6MA4bllVBBPqtZE8psfnf+7PSCxOsC4sCigQ5/rriKCUfkVR",
  cache_static_manifest: "priv/static/manifest.json"

# Do not pring debug messages in production
config :logger, level: :info

config :cedar, Cedar.Repo,
      adapter: Ecto.Adapters.Postgres,
      username: "cedar",
      password: "password",
      database: "cedar"

