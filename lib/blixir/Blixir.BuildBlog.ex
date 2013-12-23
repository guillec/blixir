defmodule Blixir.BuildBlog do

  @moduledoc """
  Handles the build of a blog.
  All sources files (posts, pages etc.) will be assembled and placed in the _blog directory
  """

  @doc """
  Builds the blog
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
  Buils blog posts and ads to _blog directory
  """

  def build_posts do
    { result, file_names } = File.ls("_sources")
    read_list_of_files(file_names)
    |> append_post_to_layout
    |> write_to_blog
  end

  @doc """
  Read list of files and return content. Returns a list of { file_name, content }
  """

  def read_list_of_files(file_names) do
    Stream.map(file_names, fn(file_name) -> 
      { file_name, File.read!("_sources/" <> file_name) }
    end)
  end

  @doc """
  Append layout to post. Returns list of { file_name, content }
  """

  def append_post_to_layout(files_and_content) do
    layout = File.read!("_layouts/" <> "default.html") 
    Stream.map(files_and_content, fn({file_name, content}) -> 
      { file_name, String.replace(layout, "{{post_body}}", content) }
    end)
  end

  @doc """
  Write post to _blog. 
  """

  def write_to_blog(files_and_content) do
    Enum.map(files_and_content, fn({file_name, content}) ->  
      File.write!("_blog/" <> file_name, content) 
    end)
  end

end
