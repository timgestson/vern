defmodule Vern.Mixfile do
  use Mix.Project

  def project do
    [app: :vern,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     dialyzer: [
       plt_apps: [:erts, :kernel, :stdlib],
       flags: [
         "-Wunmatched_returns","-Werror_handling",
         "-Wrace_conditions", "-Wno_opaque",
         "-Wno_behaviours", "-Wunderspecs", "-Woverspecs"
         ],
       paths: ["_build/dev/lib/vern/ebin", "_build/dev/lib/vern/ebin"]
       ]
     ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {Vern, []}, applications: [:logger, :hedwig]]
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
      {:hedwig, "~> 1.0.0-rc3"},
      {:tirexs, "~> 0.7.0"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:dialyxir, "~> 0.3", only: [:dev]}
    ]
  end
end
