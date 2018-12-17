defmodule PlugHackneyTraceTest.Exmaple do
  use Plug.Builder

  plug PlugHackneyTrace
  plug :hello

  def hello(conn, _opts) do
    :hackney_trace.report_event(100, 'example trace', :example_trace, [:example_trace])
    send_resp(conn, 200, "ok")
  end
end

defmodule PlugHackneyTraceTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest PlugHackneyTrace

  describe "init" do
    test "pass options" do
      assert PlugHackneyTrace.init([]) == []
      assert PlugHackneyTrace.init(trace: :min) == [trace: :min]
    end
  end

  describe "call" do
    test "call" do
      # TODO check log output
      conn(:get, "/")
      |> PlugHackneyTraceTest.Exmaple.call([])
    end
  end
end
