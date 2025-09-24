defmodule PlanAndPoker.Router do
  @doc """
  Dispatch the given "mod", "fun", "args" request
  to the appropriate node based on the "memory".
  """
  def route(memory, mod, fun, args) do
    first = :binary.first(memory)

    entry = Enum.find(table(), fn {enum, _node} ->
      first in enum
    end) || no_entry_error(memory)

    if elem(entry, 1) == node() do
      apply(mod, fun, args)
    else
      {PlanAndPoker.RouterTasks, elem(entry, 1)}
      |> Task.Supervisor.async(PlanAndPoker.Router, :route, [memory, mod, fun, args])
      |> Task.await()
    end
  end

  defp no_entry_error(memory) do
    raise "could not find entry for #{inspect memory} in table #{inspect table()}"
  end

  @doc """
  The routing table.
  """
  def table do
    [{?a..?m, :"foo@pop-os"}, {?n..?z, :"bar@pop-os"}]
  end
end
