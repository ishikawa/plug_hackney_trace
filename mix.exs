defmodule PlugHackneyTrace.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_hackney_trace,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: "A plug to enable hackney_trace",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ishikawa/plug_hackney_trace"}
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
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.19.1", only: :docs},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false}
    ]
  end
end
