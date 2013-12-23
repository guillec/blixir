defmodule BuildBlogTest do
  use ExUnit.Case

  import Mock
  import Blixir.BuildBlog

  test_with_mock "build_assets", File, [ :passthrough ], [] do
    build_assets
    assert called File.mkdir_p("_blog/assets/")
    assert called File.cp_r("_assets/.", "_blog/assets")
  end


end
