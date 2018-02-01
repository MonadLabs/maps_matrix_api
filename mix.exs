defmodule MapsMatrixApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :maps_matrix_api,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A simple interface for Google Maps Distance Matrix Api",
      aliases: aliases(),
      package: package()
    ]
  end

  defp package do
    [
      maintainers: [" Jeancarlo Barrios "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/MonadLabs/maps_matrix_api"}
    ]
  end

  defp aliases do
    [c: "compile"]
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
      {:tesla, "~> 0.10.0"}
      # {:poison, ">= 1.0.0"}
    ]
  end
end
