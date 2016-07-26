defmodule LaksBot.Mixfile do
  use Mix.Project

  def project do
    [app: :laks_bot,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :apex, :socket, :poison],
     mod: {LaksBot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:poison, "~> 2.0"},
      {:apex, "~>0.5.0"},
      {:socket, github: "meh/elixir-socket"},
      {:mock, "~> 0.1", only: :test},
      {:exrm, "~> 1.0.8"}
    ]
  end
end
