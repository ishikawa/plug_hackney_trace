defmodule PlugHackneyTrace.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_hackney_trace,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: "A plug to enable hackney_trace",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.7"},
      {:hackney, "~> 1.1"},
      {:ex_doc, "~> 0.19.1", only: :docs}
    ]
  end
end
