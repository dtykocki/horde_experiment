defmodule SuperTest.Application do
  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    topologies = [
      gossip: [strategy: Elixir.Cluster.Strategy.Gossip]
    ]

    children = [
      {
        Horde.Registry,
        name: SuperTest.Registry,
        keys: :unique,
        members: :auto,
        delta_crdt_options: [sync_interval: 1]
      },
      {
        SuperTest.MyHordeSupervisor,
          delta_crdt_options: [sync_interval: 1],
          strategy: :one_for_one,
          members: :auto,
          max_restarts: 100, max_seconds: 5
      },
      {Cluster.Supervisor, [topologies, [name: SuperTest.ClusterSupervisor]]}
    ]

    opts = [strategy: :one_for_one, name: SuperTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
