defmodule PlanAndPokerServerTest do
  use ExUnit.Case
  doctest PlanAndPokerServer

  @moduletag :capture_log

  setup do
    Application.stop(:plan_and_poker)
    :ok = Application.start(:plan_and_poker)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 4040, opts)
    %{socket: socket}
  end

  @tag :distributed
  test "server interaction", %{socket: socket} do
    assert send_and_recv(socket, "UNKNOWN gameOne\r\n") == "UNKNOWN COMMAND\r\n"
    assert send_and_recv(socket, "GET gameOne marcelo\r\n") == "NOT FOUND\r\n"
    assert send_and_recv(socket, "CREATE gameOne\n\r") == "OK\r\n"
    assert send_and_recv(socket, "PUT gameOne marcelo 1\r\n") == "OK\r\n"

    assert send_and_recv(socket, "GET gameOne marcelo\r\n") == "1\r\n"
    assert send_and_recv(socket, "") == "OK\r\n"

    assert send_and_recv(socket, "DELETE gameOne marcelo\r\n") == "OK\r\n"

    # assert send_and_recv(socket, "GET gameOne marcelo") == "\r\n"
    # assert send_and_recv(socket, "") == "OK\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
