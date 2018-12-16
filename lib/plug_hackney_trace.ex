defmodule PlugHackneyTrace do
  @moduledoc """
  A plug to enable `hackney_trace` in [hackney](https://github.com/benoitc/hackney).

  To use it, just plug it into the desired module.

  ```
  plug PlugHackneyTrace, trace: :min
  ```

  In a Phoenix powered project, you can plug it into a specific action.

  ```
  plug PlugHackneyTrace when action in [:show]
  ```

  ## Logging

  You can log the output of `hackney_trace` or handle it by a custom function. If you
  pass an `atom` for `log` option, this module will log the contents with `Logger` module.

  ```
  plug PlugHackneyTrace, log: :info
  ```

  Or you can specify the custom function for handle the output of `hackney_trace`.

  ```
  plug PlugHackneyTrace, log: fn contents -> ... end
  ```

  ## Options

  * `:log` - The log level for `Logger` or a function which handles
             contents of traces. Default is `:info`.
  * `:trace` - The trace level for `hackney_trace`. Default is `:max`.
  """

  import PlugHackneyTrace.Helpers

  require Logger

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, opts) do
    log = Keyword.get(opts, :log, :info)
    trace_level = Keyword.get(opts, :trace, :max)

    with {:ok, path} <- generate_temporary_filepath(),
         :ok <- :hackney_trace.enable(trace_level, to_charlist(path)) do
      Plug.Conn.register_before_send(conn, fn conn ->
        :hackney_trace.disable()

        with {:ok, content} <- File.read(path) do
          handle_trace_content(content, log)
        else
          {:error, posix_code} ->
            Logger.warn("Couldn't read traced contents from the file at #{path}: #{posix_code}")
        end

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

  @spec handle_trace_content(binary, atom | (binary -> any)) :: any
  defp handle_trace_content(contents, log_level) when is_atom(log_level) do
    Logger.bare_log(log_level, contents)
  end

  defp handle_trace_content(contents, handler) when is_function(handler) do
    handler.(contents)
  end

  @spec transform_error(term) :: String.t()
  defp transform_error({:error, reason}), do: inspect(reason)
  defp transform_error(error), do: inspect(error)
end
