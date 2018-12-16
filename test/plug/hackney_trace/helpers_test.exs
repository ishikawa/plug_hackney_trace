defmodule Plug.HackneyTrace.HelpersTest do
  use ExUnit.Case, async: true

  alias Plug.HackneyTrace.Helpers
  doctest Helpers

  import Mock

  describe "generate_temporary_filepath" do
    test "when system can detect a temporary directory" do
      with_mock System, [:passthrough], tmp_dir: fn -> "/tmp" end do
        assert {:ok, path} = Helpers.generate_temporary_filepath()
        assert path
      end
    end
    test "when system can't detect a temporary directory" do
      with_mock System, [:passthrough], tmp_dir: fn -> nil end do
        assert Helpers.generate_temporary_filepath() == {:error, :no_tmp_dir}
      end
    end
  end

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

  describe "tmp_dir" do
    test "when system can detect a temporary directory" do
      dir = "/tmp_dir"

      with_mock System, tmp_dir: fn -> dir end do
        assert Helpers.tmp_dir() == {:ok, dir}
      end
    end
    test "when system can't detect a temporary directory" do
      with_mock System, tmp_dir: fn -> nil end do
        assert Helpers.tmp_dir() == :error
      end
    end
  end
end
