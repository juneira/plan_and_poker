defmodule PlanAndPoker.GameStoreTest do
  alias PlanAndPoker.GameMemory

  use ExUnit.Case, async: true

  setup do
    {:ok, memory} = GameMemory.start_link(%{})
    %{memory: memory}
  end

  test "stores values by key", %{memory: memory} do
    assert GameMemory.get(memory, :any_key) == nil

    GameMemory.put(memory, :any_key, %{test: :okay})
    assert GameMemory.get(memory, :any_key) == %{test: :okay}
  end

  test "deletes values by key", %{memory: memory} do
    assert GameMemory.put(memory, :any_key, %{test: :okay})
    assert GameMemory.get(memory, :any_key) == %{test: :okay}
    assert GameMemory.delete(memory, :any_key) == %{test: :okay}
    assert GameMemory.delete(memory, :any_key) == nil
    assert GameMemory.get(memory, :any_key) == nil
  end
end
