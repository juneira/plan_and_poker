defmodule PlanAndPoker.RegistryTest do
  alias PlanAndPoker.Registry
  alias PlanAndPoker.GameMemory

  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(Registry)
    %{registry: registry}
  end

  test "spawns memories", %{registry: registry} do
    assert Registry.lookup(registry, "game one") == :error

    Registry.create(registry, "game one")
    assert {:ok, memory} = Registry.lookup(registry, "game one")

    GameMemory.put(memory, "player one", "Marcelo")
    assert GameMemory.get(memory, "player one") == "Marcelo"
  end

  test "removes memories on exit", %{registry: registry} do
    Registry.create(registry, "game one")
    assert {:ok, memory} = Registry.lookup(registry, "game one")

    Agent.stop(memory)

    assert Registry.lookup(registry, "game one") == :error
  end
end
