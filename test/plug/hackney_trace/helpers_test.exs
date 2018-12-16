defmodule Plug.HackneyTrace.HelpersTest do
  use ExUnit.Case, async: true

  alias Plug.HackneyTrace.Helpers
  doctest Helpers

  describe "generate_temporary_filename" do
    test "filename format" do
      name = Helpers.generate_temporary_filename()
      assert name =~ ~r/^hackney_trace-.+?-\d+-\d+$/
    end
  end

  describe "generate_random_id" do
    test "must be positive integer" do
      id = Helpers.generate_random_id()
      assert id > 0
    end

    test "must be unique" do
      id1 = Helpers.generate_random_id()
      id2 = Helpers.generate_random_id()
      assert id1 != id2
    end
  end
end
