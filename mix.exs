defmodule Cedar.Mixfile do
  use Mix.Project

  def project do
    [
        app: :cedar,
        version: "0.0.1",
        elixir: "~> 1.0",
        elixirc_paths: ["lib", "web"],
        compilers: [:phoenix] ++ Mix.compilers,
        deps: deps,
        external_actions: external_actions(Mix.env)
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Cedar, []},
     applications: [:phoenix, :cowboy, :logger, :httpoison]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.9.0"},
     {:cowboy, "~> 1.0"},
      {:mailgun, "~> 0.0.1"},
      {:httpoison, "~> 0.6"},
      {:uuid, "~> 0.1.5"},
      {:exrm, "~> 0.14.16"},
      {:amnesia, git: "git://github.com/meh/amnesia.git"}
    ]
  end

  defp external_actions(:test), do: false
  defp external_actions(_), do: true

end
