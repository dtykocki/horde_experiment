defmodule SuperTest.ChildOne do
  use GenServer

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    selector = Keyword.fetch!(opts, :selector)

    case GenServer.start_link(__MODULE__, %{}, name: via_tuple(name, selector)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  def put(name, selector, key, value) do
    GenServer.call(via_tuple(name, selector), {:put, key, value})
  end

  def delete(name, selector, key) do
    GenServer.call(via_tuple(name, selector), {:delete, key})
  end

  def init(initial_state) do
    {:ok, initial_state, {:continue, :more_init}}
  end

  def handle_continue(:more_init, state) do
    {:noreply, state}
  end

  def handle_call({:put, key, value}, _from, state) do
    new_state = Map.put(state, key, value)
    {:reply, new_state, new_state}
  end

  def handle_call({:delete, key}, _from, state) do
    new_state = Map.delete(state, key)
    {:reply, new_state, new_state}
  end

  defp via_tuple(name, selector) do
    {:via, Horde.Registry, {SuperTest.Registry, {name, selector}}}
  end
end
