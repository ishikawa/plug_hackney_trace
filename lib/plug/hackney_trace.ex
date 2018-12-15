defmodule Plug.HackneyTrace do
  @moduledoc """
  A plug to enable `hackney_trace` in [hackney](https://github.com/benoitc/hackney).

  To use it, just plug it into the desired module.

  ```
  plug Plug.HackneyTrace, trace: :min
  ```

  In a Phoenix powered project, you can plug it into a specific action.

  ```
  plug Plug.HackneyTrace when action in [:show]
  ```

  ## Options

  * `:trace` - The trace level for `hackney_trace`. Default is `:max`.
  """

  import Plug.HackneyTrace.Helpers

  require Logger

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, opts) do
    trace_level = Keyword.get(opts, :trace, :max)

    with {:ok, path} <- generate_temporary_filepath(),
         :ok <- :hackney_trace.enable(trace_level, to_charlist(path)) do
      Plug.Conn.register_before_send(conn, fn conn ->
        :hackney_trace.disable()

        with {:error, posix_code} <- File.rm(path) do
          Logger.warn(
            "Couldn't remove a temporary file for hackney_trace at #{path}: #{posix_code}"
          )
        end

        conn
      end)
    else
      error ->
        Logger.warn("Couldn't enable hackney_trace: #{transform_error(error)}")
        conn
    end
  end

  ## Private

  @spec transform_error(term) :: String.t
  defp transform_error({:error, reason}), do: inspect(reason)
  defp transform_error(error), do: inspect(error)
end
