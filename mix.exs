defmodule Blixir.Mixfile do
  use Mix.Project

  def project do
    [ app: :blixir,
      version: "0.0.1",
      elixir: "~> 0.13.1",
      escript_main_module: Blixir.CLI,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Blixir, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat.git" }




  # Need to add mocks for my test but its not working at the moment
  # {:mock, "~> 0.0.3", github: "jjh42/mock"}
  defp deps do
    [ 
    ]
  end
end
