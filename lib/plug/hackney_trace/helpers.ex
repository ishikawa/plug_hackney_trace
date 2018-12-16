defmodule Plug.HackneyTrace.Helpers do
  @moduledoc false

  use Bitwise, only_operators: true

  # The maximum value of random ID
  @max_random_id 1 <<< 32

  # The prefix for a temporary file
  @filename_prefix "hackney_trace"

  @spec generate_temporary_filepath() ::
          {:ok, String.t()}
          | {:error, :no_tmp_dir}
  def generate_temporary_filepath() do
    with {:ok, dir} <- tmp_dir(),
         name = generate_temporary_filename() do
      {:ok, Path.join(dir, name)}
    else
      :error -> {:error, :no_tmp_dir}
    end
  end

  @spec tmp_dir() :: {:ok, String.t()} | :error
  def tmp_dir() do
    case System.tmp_dir() do
      nil ->
        :error

      dir ->
        {:ok, dir}
    end
  end

  @spec generate_temporary_filename() :: String.t()
  def generate_temporary_filename() do
    pid = System.get_pid()
    time = System.monotonic_time(:microseconds)
    id = generate_random_id()

    "#{@filename_prefix}-#{pid}-#{time}-#{id}"
  end

  @spec generate_random_id() :: pos_integer
  def generate_random_id() do
    # :crypto.strong_rand_bytes/1 uses the OS entropy source, which is
    # relatively slow and may throw exception in certain conditions.
    :rand.uniform(@max_random_id)
  end
end
