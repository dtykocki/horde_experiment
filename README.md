# Horde Experiment

## Getting Started

Install Erlang 24.0.5 and Elixir 1.12.2 via `asdf`

```bash
asdf install
```

Install dependencies and compile.

```bash
mix deps.get && mix compile
```

Create a cluster with three nodes.

```bash
iex --name node1@127.0.0.1 --cookie asdf -S mix
iex --name node2@127.0.0.1 --cookie asdf -S mix
iex --name node3@127.0.0.1 --cookie asdf -S mix
```

Start 50 child processes and check the number of children.

```elixir
SuperTest.MyHordeSupervisor.start_n_children(:cache, 50)
SuperTest.MyHordeSupervisor.count_children
```

On any node of the three nodes, force the node to disconnect from the other nodes. Even though we are telling the node to disconnect from the other nodes, `libcluster` detects the disconnect and quickly reconnects the nodes.

```elixir
Enum.map(Node.list, &Node.disconnect/1)
Node.list
```

Check each of the nodes for crashes. Some examples:

```
05:59:37.332 [error] GenServer #PID<0.251.0> terminating
** (stop) exited in: GenServer.call(SuperTest.MyHordeSupervisor, :horde_shutting_down, 5000)
    ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
    (elixir 1.12.2) lib/gen_server.ex:1014: GenServer.call/3
    (horde 0.8.6) lib/horde/signal_shutdown.ex:21: anonymous fn/1 in Horde.SignalShutdown.terminate/2
    (elixir 1.12.2) lib/enum.ex:930: Enum."-each/2-lists^foreach/1-0-"/2
    (stdlib 3.15.2) gen_server.erl:733: :gen_server.try_terminate/3
    (stdlib 3.15.2) gen_server.erl:918: :gen_server.terminate/10
    (stdlib 3.15.2) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:EXIT, #PID<0.247.0>, :shutdown}
State: [SuperTest.MyHordeSupervisor]

05:59:37.650 [error] GenServer SuperTest.MyHordeSupervisor terminating 
** (stop) exited in: GenServer.call(SuperTest.MyHordeSupervisor.ProcessesSupervisor, {:start_child, {97503007365355280592211088211697061465, {SuperTest.ChildOne, :start_link, [[name: :cache, selector: 2]]}, :permanent, 5000, :worker, [SuperTest.ChildOne]}}, :infinity)
** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly becaus
e its application isn't started
    (elixir 1.12.2) lib/gen_server.ex:1014: GenServer.call/3
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:724: anonymous fn/2 in Horde.DynamicSupervisorImpl.add_children/2
    (elixir 1.12.2) lib/enum.ex:1582: Enum."-map/2-lists^map/1-0-"/2
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:723: Horde.DynamicSupervisorImpl.add_children/2
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:718: Horde.DynamicSupervisorImpl.add_child/2
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:457: Horde.DynamicSupervisorImpl.update_process/2
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:446: Horde.DynamicSupervisorImpl.update_processes/2
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:367: Horde.DynamicSupervisorImpl.handle_info/2
Last message: {:crdt_update, [{:add, {:process, 97503007365355280592211088211697061465}, {nil, %{id: 97503007365355280592211088211
697061465, start: {SuperTest.ChildOne, :start_link, [[name: :cache, selector: 2]]}}}}]}

05:59:37.948 [error] GenServer SuperTest.MyHordeSupervisor terminating
** (MatchError) no match of right hand side value: nil
    (horde 0.8.6) lib/horde/dynamic_supervisor_impl.ex:219: Horde.DynamicSupervisorImpl.handle_cast/2
    (stdlib 3.15.2) gen_server.erl:695: :gen_server.try_dispatch/4
    (stdlib 3.15.2) gen_server.erl:771: :gen_server.handle_msg/6
    (stdlib 3.15.2) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:"$gen_cast", {:relinquish_child_process, 199548840804516766460048281412166721469}}
```