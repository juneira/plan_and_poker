defmodule PlanAndPoker.GameStoreTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, memory} = PlanAndPoker.GameMemory.start_link(%{})
    %{memory: memory}
  end

  test "stores values by key", %{memory: memory} do
    assert PlanAndPoker.GameMemory.get(memory, :any_key) == nil

    PlanAndPoker.GameMemory.put(memory, :any_key, %{test: :okay})
    assert PlanAndPoker.GameMemory.get(memory, :any_key) == %{test: :okay}
  end

  test "deletes values by key", %{memory: memory} do
    assert PlanAndPoker.GameMemory.put(memory, :any_key, %{test: :okay})
    assert PlanAndPoker.GameMemory.get(memory, :any_key) == %{test: :okay}
    assert PlanAndPoker.GameMemory.delete(memory, :any_key) == %{test: :okay}
    assert PlanAndPoker.GameMemory.delete(memory, :any_key) == nil
    assert PlanAndPoker.GameMemory.get(memory, :any_key) == nil
  end
end
