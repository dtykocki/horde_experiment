defmodule SuperTest.Application do
  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    topologies = [
      gossip: [strategy: Elixir.Cluster.Strategy.Gossip]
    ]

    children = [
      {Horde.Registry, name: SuperTest.Registry, keys: :unique, members: :auto},
      {SuperTest.MyHordeSupervisor, strategy: :one_for_one, members: :auto},
      {Cluster.Supervisor, [topologies, [name: SuperTest.ClusterSupervisor]]}
    ]

    opts = [strategy: :one_for_one, name: SuperTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
