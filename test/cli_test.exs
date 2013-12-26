defmodule CliTest do
  use ExUnit.Case

  import Blixir.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "when `new` is passed" do
    assert parse_args(["new"]) == { "new" }
  end

  test "one value returned if one givien" do
    assert parse_args(["build"]) == { "build" }
  end

end
