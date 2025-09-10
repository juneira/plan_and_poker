defmodule PlanAndPoker.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {PlanAndPoker.Registry, name: PlanAndPoker.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
