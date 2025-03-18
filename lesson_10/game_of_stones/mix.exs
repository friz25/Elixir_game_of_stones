defmodule GameOfStones.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_of_stones,

      #[11] для запуска GameOfStones.Client.main() /запуска через >>game_of_stones --stones 30
      escript: escript_config(),

      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [ default_gamestart_stones: 30 ], #[11]
      mod: { #mod = модуль
        GameOfStones.Application, [] #[11]тут подключили Supervisor
      },
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp escript_config do #[11]
    [
      main_module: GameOfStones.Client
    ]
  end
end
