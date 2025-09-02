defmodule PlanAndPoker.GameMemory do
  use Agent

  @doc """
  Starts a new game memory.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a game state by key.
  """
  def get(memory, key) do
    Agent.get(memory, &Map.get(&1, key))
  end

  @doc """
  Puts the state for the given key in the game memory
  """
  def put(memory, key, state) do
    Agent.update(memory, &Map.put(&1, key, state))
  end
end
