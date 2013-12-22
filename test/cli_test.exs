defmodule CliTest do
  use ExUnit.Case

  import Mock
  import Blixir.CLI#, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "two values returned if two givien" do
    assert parse_args(["new", "blog_name"]) == { "new", "blog_name" }
  end

  test_with_mock "directory created", File, [ :passthrough ], [] do
    dir_name = "test_name"
    create_dir(dir_name)
    assert called File.mkdir_p(dir_name)
  end

  test_with_mock "file created", File, [ :passthrough ], [] do
    file_name = "index.html"
    path      = "blog_name/_pages/" <> file_name
    content   = "<HTML>...</HTML>"
    create_page(path, content)
    assert called File.write(path, content)
  end

end
