defmodule SuperTest.MyHordeSupervisor do
  use Horde.DynamicSupervisor

  def start_link(args \\ %{}) do
    Horde.DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    Horde.DynamicSupervisor.init(args)
  end

  def start_child(name, selector) do
    child_spec = {SuperTest.ChildOne, [name: name, selector: selector]}
    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def terminate_child(name, selector) do
    case Horde.Registry.lookup(SuperTest.Registry, {name, selector}) do
      [{pid, nil}] ->
        Horde.DynamicSupervisor.terminate_child(__MODULE__, pid)
      _ ->
        :no_child
    end
  end

  def start_n_children(name, n) do
    Enum.map(1..n, fn n -> start_child(name, n) end)
  end

  def start_ten_children do
    start_n_children(:cache, 10)
  end

  def delta_crdt_state do
    DeltaCrdt.to_map(SuperTest.MyHordeSupervisor.Crdt)
  end

  def terminate_children do
    Enum.map(Horde.DynamicSupervisor.which_children(__MODULE__), fn {_, pid, _, _} ->
      Horde.DynamicSupervisor.terminate_child(__MODULE__, pid)
    end)
  end

  def count_children do
    Horde.DynamicSupervisor.count_children(__MODULE__)
  end

  def which_children do
    Horde.DynamicSupervisor.which_children(__MODULE__)
  end

  def disconnect do
    Enum.map(Node.list, &Node.disconnect/1)
  end
end
