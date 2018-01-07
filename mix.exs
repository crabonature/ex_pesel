defmodule ExPesel.MixProject do
  use Mix.Project

  @version "0.1.0"

  @description "Library for PESEL number."
  @repo_url "https://github.com/crabonature/ex_pesel"
  @docs "https://hexdocs.pm/ex_pesel"

  def project do
    [
      app: :ex_pesel,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: @description,
      package: package(),
      # docs
      homepage_url: @docs,
      source_url: @repo_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib/**/*.ex", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Marcin Szczepaniak"],
      licenses: ["Apache 2.0"],
      links: %{
	"GitHub" => @repo_url,
	"Docs" => @docs
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc,   "~> 0.18.1", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5",    only: :dev, runtime: false},
      {:credo,    "~> 0.8",    only: [:dev, :test], runtime: false}
    ]
  end
end
