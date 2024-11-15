defmodule VideoGenerator.FFmpeg do
  def create_video(image_path, text, output_path, opts \\ []) do
    final_output_path =
      case Keyword.get(opts, :overwrite, true) do
        true ->
          # Overwrite existing file
          output_path

        false ->
          # Append timestamp to filename
          extension = Path.extname(output_path)
          base_path = Path.rootname(output_path)
          timestamp = DateTime.utc_now() |> DateTime.to_unix()
          "#{base_path}_#{timestamp}#{extension}"
      end

    command =
      "ffmpeg -y -loop 1 -i #{image_path} " <>
        "-vf \"scale=trunc(iw/2)*2:trunc(ih/2)*2,drawtext=text='#{text}':fontsize=24:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2\" " <>
        "-t 5 -pix_fmt yuv420p #{final_output_path}"

    System.cmd("bash", ["-c", command])
  end
end
