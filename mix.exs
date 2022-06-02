defmodule BaseUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :base_ui,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_view, "~> 0.17.9"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:jason, "~> 1.3"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
