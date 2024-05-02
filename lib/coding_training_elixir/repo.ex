defmodule CodingTrainingElixir.Repo do
  use Ecto.Repo,
    otp_app: :coding_training_elixir,
    adapter: Ecto.Adapters.Postgres
end
