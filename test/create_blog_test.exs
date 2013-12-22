defmodule CreateBlogTest do
  use ExUnit.Case

  import Mock
  import Blixir.CreateBlog, only: [ create_dir: 1, create_page: 2]

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
