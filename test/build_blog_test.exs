defmodule BuildBlogTest do
  use ExUnit.Case

  import Mock
  import Blixir.BuildBlog

  test_with_mock "build_assets", File, [ :passthrough ], [] do
    build_assets

    assert called File.mkdir_p("_blog/assets/")
    assert called File.cp_r("_assets/.", "_blog/assets")
  end

  test "get_list_of_files" do
    list_of_files = get_list_of_files("test/fake_blog/_sources/")

    assert Enum.find(list_of_files, fn(file_name) ->
      file_name == "test/fake_blog/_sources/fake_blog_post.html"
    end )
  end

  test "read_content_of_files" do
    list_of_files = get_list_of_files("test/fake_blog/_sources")
    files_content = read_content_of_files(list_of_files)

    assert Enum.find(files_content, fn({_, content}) ->
      String.contains?(content, "{{fake_blog_post}}")
    end )
  end

  test "append_widgets" do
    content     = "This is content {{recent_posts}}"
    new_content = append_widgets(content)

    assert String.contains?(new_content, "</ul>")
  end

  test "write_to_blog" do
    File.mkdir_p("test/fake_blog/_blog/")

    list_of_files = get_list_of_files("test/fake_blog/_sources")
    files_content = read_content_of_files(list_of_files)

    write_to_blog("test/fake_blog/_blog/", files_content)

    list_of_posts = get_list_of_files("test/fake_blog/_blog/")

    assert Enum.find(list_of_posts, fn (posts) -> 
      posts == "test/fake_blog/_blog/fake_blog_post.html"
    end)

    File.rm_rf!("test/fake_blog/_blog")
  end

  test "create_title" do
    title = create_title("the_page_title.html")
    assert title == "The page title"

    title = create_title("thetitle.html")
    assert title == "Thetitle"
  end

end
