defmodule PlanAndPoker.Registry do
  use GenServer

  # Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the memory pid for name stored in server.

  Returns {:ok, pid} if the bucket exists, :error otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a memory associated with the given name in server.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  # GenServer Callbacks

  @impl true
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, memory} = PlanAndPoker.GameMemory.start_link([])
      ref = Process.monitor(memory)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, memory)
      {:noreply, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, reference, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, reference)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(message, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(message)}")
    {:noreply, state}
  end
end
