defmodule Majudge.Repo do
  use Ecto.Repo,
    otp_app: :majudge,
    adapter: Ecto.Adapters.Postgres
end
