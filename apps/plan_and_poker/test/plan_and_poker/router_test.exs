defmodule PlanAndPoker.RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
  test "route requests across nodes" do
    assert PlanAndPoker.Router.route("hello", Kernel, :node, []) == :"foo@pop-os"
    assert PlanAndPoker.Router.route("world", Kernel, :node, []) == :"bar@pop-os"
  end
end
