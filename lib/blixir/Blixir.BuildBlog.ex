defmodule Blixir.BuildBlog do

  @moduledoc """
  Handles all aspects of building the blog. 
  This includes appending all layouts to the posts and widgets.
  All sources files (posts, pages etc.) will be assembled and placed in the _blog directory
  """

  @doc """
  Builds the entire blog.
  """
  def process do
    IO.puts "Building your blog!"
    build_assets
    build_posts
    IO.puts "Done!"
  end

  @doc """
  Moves assets from root directory to _blog/assets/
  """

  def build_assets do
    File.mkdir_p("_blog/assets/")
    File.cp_r("_assets/.", "_blog/assets")
  end

  @doc """
  Builds blog posts and ads to _blog directory
  """

  def build_posts do
    get_list_of_files("_sources")
    |> read_content_of_files
    |> build_post
    |> write_to_blog
  end

  @doc """
  Return list of file names from a directory. `dir` is the directory you want to search.
  """

  def get_list_of_files(dir) do
    { result, file_names } = File.ls(dir)
    Enum.map(file_names, fn(file_name) ->
      Path.absname(file_name, dir <> "/")
    end)
  end

  @doc """
  Read list of files and returns content. `file_names` is the list of files you want to read from. Returns a list of { file_name, content }
  """

  def read_content_of_files(file_names) do
    Stream.map(file_names, fn(file_name) -> 
      { file_name, File.read!(file_name) }
    end)
  end

  @doc """
  Builds the blog posts by appending the layouts, appending the widgets and setting all configurations.
  Returns a list of { file_name, completed_post }
  """

  def build_post(files_and_content) do
    layout = File.read!("_layouts" <> "/default.html") 
    Stream.map(files_and_content, fn({file_name, content}) -> 
      post_body = replace_keyword(layout, "{{post_body}}", content)
      post_body = append_widgets(post_body)
      { file_name, post_body }
    end)
  end

  @doc """
  Append widgets to post. Returns string of the body. `content` is the body of the post.
  """

  def append_widgets(content) do
    new_body        = content
    widgets_names   = get_list_of_files("_widgets")
    widgets_content = read_content_of_files(widgets_names)
    Enum.reduce(widgets_content, new_body, fn({widget_name, widget_content}, new_body) -> 
      keyword  =  String.replace(Path.basename(widget_name), ".html", "")
      new_body = replace_keyword(new_body, "{{" <> keyword <> "}}", widget_content)
    end)
  end

  @doc """
  Replaces a keyword with a new string. 
  `template` is the string you are going to search
  `keyword` is the word you are looking to replace
  `content` is the content you want to replace the keyword with
  """

  def replace_keyword(template, keyword, content) do
    String.replace(template, keyword, content)
  end

  @doc """
  Creates a file in `write_to // _blog`.
  """

  def write_to_blog(write_to // "_blog/", files_and_content) do
    Enum.map(files_and_content, fn({file_name, content}) ->  
      File.write(write_to <> Path.basename(file_name), content) 
    end)
  end

end
