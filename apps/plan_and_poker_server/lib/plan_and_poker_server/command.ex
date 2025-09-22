defmodule PlanAndPokerServer.Command do
  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:create, memory}) do
    PlanAndPoker.Registry.create(PlanAndPoker.Registry, memory)
    {:ok, "OK\r\n"}
  end

  def run({:get, memory, key}) do
    lookup(memory, fn pid ->
      value = PlanAndPoker.GameMemory.get(pid, key)
      {:ok, "#{value}\r\nOK\r\n"}
    end)
  end

  def run({:put, memory, key, value}) do
    lookup(memory, fn pid ->
      PlanAndPoker.GameMemory.put(pid, key, value)
      {:ok, "OK\r\n"}
    end)
  end

  def run({:delete, memory, key}) do
    lookup(memory, fn pid ->
      PlanAndPoker.GameMemory.delete(pid, key)
      {:ok, "OK\r\n"}
    end)
  end

  defp lookup(memory, callback) do
    case PlanAndPoker.Registry.lookup(PlanAndPoker.Registry, memory) do
      {:ok, pid} -> callback.(pid)
      :error -> {:error, :not_found}
    end
  end

  @doc ~S"""
  Parses the given 'line' into a command.

  ## Examples

  iex> PlanAndPokerServer.Command.parse("CREATE gameOne\r\n")
  {:ok, {:create, "gameOne"}}

  iex> PlanAndPokerServer.Command.parse("CREATE gameOne  \r\n")
  {:ok, {:create, "gameOne"}}

  iex> PlanAndPokerServer.Command.parse("PUT gameOne marcelo 1\r\n")
  {:ok, {:put, "gameOne", "marcelo", "1"}}

  iex> PlanAndPokerServer.Command.parse("GET gameOne marcelo\r\n")
  {:ok, {:get, "gameOne", "marcelo"}}

  iex> PlanAndPokerServer.Command.parse("DELETE gameOne marcelo\r\n")
  {:ok, {:delete, "gameOne", "marcelo"}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

  iex> PlanAndPokerServer.Command.parse "UNKNOWN gameOne marcelo\r\n"
  {:error, :unknown_command}

  iex> PlanAndPokerServer.Command.parse "GET gameOne\r\n"
  {:error, :unknown_command}
  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", memory] -> {:ok, {:create, memory}}
      ["GET", memory, key] -> {:ok, {:get, memory, key}}
      ["PUT", memory, key, value] -> {:ok, {:put, memory, key, value}}
      ["DELETE", memory, key] -> {:ok, {:delete, memory, key}}
      _ -> {:error, :unknown_command}
    end
  end
end
