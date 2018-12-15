defmodule Plug.HackneyTraceTest do
  use ExUnit.Case, async: true

  doctest Plug.HackneyTrace

  describe "init" do
    test "pass options" do
      assert Plug.HackneyTrace.init([]) == []
      assert Plug.HackneyTrace.init(trace: :min) == [trace: :min]
    end
  end
end
