defmodule VideoGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies, [])
    IO.inspect(topologies, label: "Loaded topologies")

    children = [
      VideoGeneratorWeb.Telemetry,
      VideoGenerator.Repo,
      {DNSCluster, query: Application.get_env(:video_generator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VideoGenerator.PubSub},
      {Finch, name: VideoGenerator.Finch},
      VideoGeneratorWeb.Endpoint,
      {Oban, oban_config()},
      {Cluster.Supervisor, [topologies, [name: VideoGenerator.ClusterSupervisor]]}
    ]

    opts = [strategy: :one_for_one, name: VideoGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  @spec config_change(any(), any(), any()) :: :ok
  def config_change(changed, _new, removed) do
    VideoGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.get_env(:video_generator, Oban)
  end
end
