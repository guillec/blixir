defmodule CliTest do
  use ExUnit.Case

  import Blixir.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "two values returned if two givien" do
    assert parse_args(["new", "blog_name"]) == { "new", "blog_name" }
  end

end
