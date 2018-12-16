defmodule Plug.HackneyTrace.HelpersTest do
  use ExUnit.Case, async: true

  alias Plug.HackneyTrace.Helpers
  doctest Helpers

  describe "generate_temporary_filename" do
    test "filename format" do
      name = Helpers.generate_temporary_filename()
      assert name =~ ~r/^hackney_trace-.+?-\d+-.+$/
    end
  end
end
