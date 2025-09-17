defmodule PlanAndPokerServerTest do
  use ExUnit.Case
  doctest PlanAndPokerServer

  test "greets the world" do
    assert PlanAndPokerServer.hello() == :world
  end
end
