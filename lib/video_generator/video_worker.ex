defmodule VideoGenerator.VideoWorker do
  use Oban.Worker, queue: :default, max_attempts: 5

  alias VideoGenerator.FFmpeg

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"image_path" => image_path, "text" => text, "output_path" => output_path}
      }) do
    FFmpeg.create_video(image_path, text, output_path)
    :ok
  end
end
