defmodule PlugHackneyTraceTest do
  use ExUnit.Case, async: true

  doctest PlugHackneyTrace

  describe "init" do
    test "pass options" do
      assert PlugHackneyTrace.init([]) == []
      assert PlugHackneyTrace.init(trace: :min) == [trace: :min]
    end
  end
end
