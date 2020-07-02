defmodule Exawesome.Repo do
  use Ecto.Repo,
    otp_app: :exawesome,
    adapter: Ecto.Adapters.Postgres
end
