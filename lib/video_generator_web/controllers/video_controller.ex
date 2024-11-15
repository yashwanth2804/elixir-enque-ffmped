defmodule VideoGeneratorWeb.VideoController do
  use VideoGeneratorWeb, :controller

  alias VideoGenerator.VideoWorker

  def generate(conn, %{"image_path" => image_path, "text" => text, "output_path" => output_path}) do
    %{
      "image_path" => image_path,
      "text" => text,
      "output_path" => output_path
    }
    |> VideoWorker.new()
    |> Oban.insert()

    text = "Video generation job has been enqueued."

    conn
    |> put_flash(:info, text)
    |> redirect(to: "/")
  end
end
