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
end
