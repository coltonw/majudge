# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :majudge,
  ecto_repos: [Majudge.Repo]

# Configures the endpoint
config :majudge, MajudgeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tl88PeBdzkOW55OOQ0MlELI7cTVrasGbdh4jIGIiMxXML3/PfEaGSij8ne1WicKq",
  render_errors: [view: MajudgeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Majudge.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  # debug_requests: true,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "us-east-1",
  json_codec: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
