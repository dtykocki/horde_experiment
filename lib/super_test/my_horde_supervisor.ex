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

  def start_n_children(name, n) do
    Enum.map(1..n, fn n -> start_child(name, n) end)
  end

  def count_children do
    Horde.DynamicSupervisor.count_children(__MODULE__)
  end

  def which_children do
    Horde.DynamicSupervisor.which_children(__MODULE__)
  end
end
