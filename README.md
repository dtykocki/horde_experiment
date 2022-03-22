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

Start 10 child processes.

```elixir
SuperTest.MyHordeSupervisor.start_n_children(:cache, 10)
[
  ok: #PID<0.274.0>,
  ok: #PID<20497.277.0>,
  ok: #PID<20601.279.0>,
  ok: #PID<20497.278.0>,
  ok: #PID<20497.279.0>,
  ok: #PID<0.275.0>,
  ok: #PID<20497.280.0>,
  ok: #PID<20601.280.0>,
  ok: #PID<20497.281.0>,
  ok: #PID<0.276.0>
]
```

Check the DynamicSupervisor's CRDT. Expect to see 10 processes and their child IDs.

```elixir
SuperTest.MyHordeSupervisor.delta_crdt_state |> Map.keys |> Keyword.take([:process])
[
  process: 68392088219703757673972164122486143230,
  process: 105552886181917832014522691685892973551,
  process: 129070574946004734499112794734408027520,
  process: 195107849613896050480906631849130768071,
  process: 196784937736595347354639926762177549776,
  process: 204437240392199263913201583471062927966,
  process: 215109988850775608765415495851697934892,
  process: 244799407463025530050976340829007469841,
  process: 317732209698850537282412737500954541736,
  process: 317869322989008501569082086608844104553
]
```

Choose any of the three nodes and gracefully stop the node.

```elixir
System.stop
```

On one of the remaining nodes, check the DynamicSupervisor's CRDT again. There will now be duplicate references.

```elixir
SuperTest.MyHordeSupervisor.delta_crdt_state |> Map.keys |> Keyword.take([:process])
[
  process: 68392088219703757673972164122486143230,
  process: 105552886181917832014522691685892973551,
  process: 129070574946004734499112794734408027520,
  process: 142650926805914478270707104106868297093,
  process: 157287460824158580983611777505894428390,
  process: 195107849613896050480906631849130768071,
  process: 196784937736595347354639926762177549776,
  process: 204437240392199263913201583471062927966,
  process: 215109988850775608765415495851697934892,
  process: 232006903589023160387067214004718991335,
  process: 244799407463025530050976340829007469841,
  process: 317732209698850537282412737500954541736,
  process: 317869322989008501569082086608844104553
]
```