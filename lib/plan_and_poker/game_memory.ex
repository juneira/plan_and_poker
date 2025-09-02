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
  Puts the state for the given key in the game memory.
  """
  def put(memory, key, state) do
    Agent.update(memory, &Map.put(&1, key, state))
  end

  @doc """
  Deletes the state by key.

  Returns the current value of key, if key exists.
  """
  def delete(memory, key) do
    Agent.get_and_update(memory, &Map.pop(&1, key))
  end
end
