defmodule Plug.HackneyTrace.Helpers do
  @moduledoc false

  # The number of bytes for random bytes
  @n_rand_bytes 32

  # The prefix for a temporary file
  @filename_prefix "hackney_trace"

  @spec generate_temporary_filepath() ::
          {:ok, String.t()}
          | {:error, reason :: term}
  def generate_temporary_filepath() do
    with {:ok, dir} <- tmp_dir(),
         name = generate_temporary_filename() do
      Path.join(dir, name)
    end
  end

  @spec tmp_dir() :: {:ok, String.t()} | {:error, reason :: term}
  def tmp_dir() do
    case System.tmp_dir() do
      nil ->
        {:error, :no_tmp_dir}

      dir ->
        {:ok, dir}
    end
  end

  @spec generate_temporary_filename() :: String.t
  def generate_temporary_filename() do
    pid = System.get_pid()
    time = System.monotonic_time(:microseconds)
    uid = generate_uid()

    "#{@filename_prefix}-#{pid}-#{time}-#{uid}"
  end

  @spec generate_uid() :: String.t()
  def generate_uid() do
    try do
      :crypto.strong_rand_bytes(@n_rand_bytes)
      |> Base.encode16(case: :lower)
    catch
      :error, :low_entropy ->
        to_string(System.unique_integer([:positive]))
    end
  end
end
