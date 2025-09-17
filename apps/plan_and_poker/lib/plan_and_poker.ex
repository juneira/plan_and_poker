defmodule PlanAndPoker do
  use Application

  @impl true
  def start(_type, _args) do
    PlanAndPoker.Supervisor.start_link(name: PlanAndPoker.Supervisor)
  end
end
