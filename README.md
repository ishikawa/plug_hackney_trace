# Plug.HackneyTrace

A plug to enable `hackney_trace` in [hackney](https://github.com/benoitc/hackney).

With this plug, you can easily enable `hackney_trace` for your desired controller or the specific action. Furthermore, this plug automatically handles the output of `hackney_trace` and convert it into Elixir `String`. You can log it or handle by your own function.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_hackney_trace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_hackney_trace, "~> 0.1.0"}
  ]
end
```

To use it, just plug it into the desired module.

```elixir
plug Plug.HackneyTrace, trace: :min
```

In a Phoenix powered project, you can plug it into a specific action.

```elixir
plug Plug.HackneyTrace when action in [:show]
```

## License

See [LICENSE](https://github.com/ishikawa/plug_hackney_trace/blob/master/LICENSE) file.
