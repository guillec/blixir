defmodule BuildBlogTest do
  use ExUnit.Case

  import Mock
  import Blixir.BuildBlog

  test_with_mock "build_assets", File, [ :passthrough ], [] do
    build_assets
    assert called File.mkdir_p("_build/assets/")
    assert called File.copy("_assets/*", "_build/assets/")
  end


end
