defmodule FkcElixir.Repo do
  use Ecto.Repo,
    otp_app: :fkc_elixir,
    adapter: Ecto.Adapters.Postgres
end
