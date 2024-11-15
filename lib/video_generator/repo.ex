defmodule VideoGenerator.Repo do
  use Ecto.Repo,
    otp_app: :video_generator,
    adapter: Ecto.Adapters.Postgres
end
