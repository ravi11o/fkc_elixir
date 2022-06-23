import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :fkc_elixir, FkcElixir.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "fkc_elixir_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fkc_elixir, FkcElixirWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xWw/MYQBahN5Bha/h4qHYVIljxhit8Gd7LlSyrgRkTNdU3gIsvh5Yd6pAkLkkN8U",
  server: false

# In test we don't send emails.
config :fkc_elixir, FkcElixir.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
