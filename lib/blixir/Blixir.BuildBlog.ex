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
    build_all("_sources")
    build_all("_pages")
    build_index_page
    IO.puts "Done!"
  end

  def build_index_page do
    page_feed = ""
    get_list_of_files("_sources")
    |> read_content_of_files
    |> Enum.map(fn({file_name, content}) ->
      content = append_post_template(content)
      content = set_read_more(content)
      content = set_meta_data(file_name, content)
      {file_name, content}
    end)
    |> Enum.reduce("", fn({file_name, content}, page_feed) -> 
      page_feed <> content
    end)
    |> append_to_index
  end

  def set_read_more(content) do
     replace_keyword(content, "{{read_more}}", "<p class='text-align-center'><a href='{{href}}' class='button medium grey'>Comment</a></p>")
  end

  def append_to_index(write_to \\ "_blog/", content) do
    if Mix.env == :test do
      { page_status, page_content } = File.read("test/fake_blog/_sources/index.html")
    else
      { page_status, page_content } = File.read("_pages/index.html")
      { page_status, layout_content } = File.read("_layouts/index.html")
    end

    index_page = replace_keyword(page_content, "{{posts}}", content)
    index_page = replace_keyword(layout_content, "{{page_content}}", index_page)
    index_page = append_widgets(index_page)
    write_to_blog(write_to, [{"index.html", index_page}])
  end

  @doc """
  Copy assets from root/_assets directory to _blog/assets/
  """

  def build_assets do
    File.mkdir_p("_blog/assets/")
    File.cp_r("_assets/.", "_blog/assets")
  end

  @doc """
  Builds blog posts and add to _blog directory
  """

  def build_all(files) do
    get_list_of_files(files)
    |> read_content_of_files
    |> build_post
    |> write_to_blog
  end

  @doc """
  Return list of file names from a directory. `dir` is the directory you want to search.
  """

  def get_list_of_files(dir) do
    { result, file_names } = File.ls(dir)

    files = Enum.map(file_names, fn (file_name) ->
      Path.absname(file_name, dir <> "/")
    end)

    Enum.sort(files, fn (file_one, file_two) ->
      { result_1, stats_1 } = File.stat(file_one)
      { result_2, stats_2 } = File.stat(file_two)
      stats_1.ctime > stats_2.ctime
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
  Append the layout to the file
  """
  def append_layout(file_name, content) do
      # Is there a layout with the same name as the file?
      { status,  layout } = File.read("_layouts/" <> Path.basename(file_name))

      # Use default layout if no other layout is found for page
      if status != :ok do
        { status,  layout } = File.read("_layouts/" <> "default.html") 
      end

      post_body = replace_keyword(layout, "{{page_content}}", content)
  end

  @doc """
  Append the posts layout to the file
  """
  def append_post_template(content) do
      # Use default layout if no other layout is found for page
      { status,  layout } = File.read("_layouts/post.html") 

      post_body = replace_keyword(layout, "{{post_body}}", content)
  end

  @doc """
  Builds the blog posts by appending the layouts, appending the widgets and setting all configurations.
  Returns a list of { file_name, completed_post }
  """

  def build_post(files_and_content) do
    Stream.map(files_and_content, fn({file_name, content}) -> 
      post_body = append_post_template(content)
      post_body = append_layout(file_name, post_body)
      post_body = set_meta_data(file_name, post_body)
      post_body = append_widgets(post_body)
      post_body = replace_keyword(post_body, "{{read_more}}", "")
      { file_name, post_body }
    end)
  end

  def set_meta_data(file_name, post_body) do
    #Get the meta data keys
    regex_matches = Regex.scan(%r/#.*:.*$/m, post_body)
    post_body = Enum.reduce(regex_matches, post_body, fn([x | tail], post_body) -> 
        if x != nil do
          [head | tail] = Regex.run(%r/#.*:/f, x) 
          image_path = replace_keyword(x, head, "")
          meta_key   = replace_keyword(head, "#", "")
          meta_key   = replace_keyword(meta_key, ":", "")
          post_body  = replace_keyword(post_body, "{{" <> meta_key <>"}}", String.strip(image_path))

          #set the href to the page
          post_body  = replace_keyword(post_body, x, "")
          post_body  = replace_keyword(post_body, "{{href}}", Path.basename(file_name))
        end
        post_body
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
      new_body
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

  def write_to_blog(write_to \\ "_blog/", files_and_content) do
    Enum.map(files_and_content, fn({file_name, content}) ->  
      File.write(write_to <> Path.basename(file_name), content) 
    end)
  end

end
