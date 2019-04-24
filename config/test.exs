use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :siano, SianoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :siano, Siano.Repo,
  username: "postgres",
  password: "postgres",
  database: "siano_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Password hashing test config
config :bcrypt_elixir, :log_rounds, 4

# Mailer test configuration
config :siano, SianoWeb.Mailer,
  adapter: Bamboo.TestAdapter
