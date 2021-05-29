defmodule Metapede.Repo do
  use Ecto.Repo,
    otp_app: :metapede,
    adapter: Ecto.Adapters.Postgres
end
