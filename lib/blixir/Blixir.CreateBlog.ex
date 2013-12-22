defmodule Blixir.CreateBlog do

  @moduledoc """
  Handle the command line parsing and the call to run the application.
  """

  @index_page_content """
    --title: Your First Page
    --end_config
    <p>
      All right, You just setup your blog! Now what?<br/>
      Well there are couple of things you can do, add a new post, create a new page or edit the layout! For more information on this check out the README.
    </p>
    <p>
      The other thing you can do is look at the code and help me make this better. Check out the README on how to contribute.
    </p>
    <p>
      Is Bluag for you? I dont know, but if you are looking to start a blog and don't want to use a annoying CMS you should try this.
      You should especially try this if you are a Lua developer, since all the code is written in Lua. I hope that with Bluag, 
      as a developer you can just easily manipulate the content of your post and just over all have more fun.
    </p>
    <p>
      There is a lot more that can be done and I am always looking for feedback. Please if interested help me with this project.
    </p>
    <br/>
    {{posts}}
  """

  @default_layout_content """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
          {{title}}
        </title>
        <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" rel="stylesheet">
        <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">
        {{stylesheets}}
      </head>
      <body>
        <div class="row-fluid" style="background-color: white; padding: 20px;">
          <span class="row">
            <span class="offset1">
              <img src="http://www.pairprogramwith.me/badge.png" alt="pair with me logo" />
            </span>
            {{top_menu}}
          </span>
        </div>
        <div class="row-fluid" style="padding-top: 35px;">
          <div class="span10 offset1">{{post_body}}</div>
        </div>
        <div id="footer" class="row-fluid" style="padding-top: 15px;">
        </div>
        <script>
        <!-- Google Analytics Here -->
        </script>
      </body>
    </html>
  """

  @recent_posts_content """
    <ul class="unstyled" style="padding-top: 10px;">
      <li style="border-bottom: solid 1px #999999; padding: 7px 0px;">
        <a href='/index.html'>Your Bluag Blog</a>
        <span style="float: right;" class="muted"><small>11/11/1111</small></span>
      </li>
    </ul>
  """

  @top_menu_content """
    <span class="offset3" style="font-size: 20px; word-spacing: 5px;">
      <a href="/index.html" rel="index" rel="index">HOME</a>
       | 
      <a href="#" rel="index" rel="about">ABOUT ME</a>
       | 
      <a href="#" rel="projects">PROJECTS</a>
    </span>
  """

  @stylesheet_content """
    html,body {
      height: 100%;
      background-color: #f2f2f2;
    }

    #footer{
      bottom: -50px;
      height: 50px;
      left: 0;
      position: absolute;
      right: 0;
    }

    hr {
      margin-top: 50px;
      margin-bottom: 50px;
      height: 1px;
      border: 0; border-top: 1px solid #ccc
    }

    span.label {
      margin-top: 10px;
      margin-right: 15px;
      padding: 15px;
      float: left;
    }

    div.post-header {
      margin-top: 15px;
      margin-bottom: 30px;
    }
  """

  @stylesheet_widget_content """
    <link rel="stylesheet" href="assets/stylesheets/style.css">
  """

  @first_post_content """
    --title: Your First Blog Post
    --end_config

    <br/>
    <h3>Your First Post</h3>
    <p>This file is found in the <em>_sources</em> directory. If you want to add a new blog post just create a new html file in the <em>_sources</em> directory.</p>
    <p>
      <strong>VERY IMPORTANT:</strong> every file in the <em>_sources</em> directory <strong>requires</strong> a title config block. 
      Look at the source file as an example. Without this the build will break.
     </p>
  """

  def process({new, blog_name}) do
    create_dir(blog_name)
    create_dir(blog_name <> "/_sources")
    create_dir(blog_name <> "/_pages")
    create_dir(blog_name <> "/_layouts")
    create_dir(blog_name <> "/_build/")
    create_dir(blog_name <> "/_widgets/")
    create_dir(blog_name <> "/_assets")
    create_dir(blog_name <> "/_assets/stylesheets")
    create_dir(blog_name <> "/_assets/images")

    create_page(blog_name <> "/_pages/index.html", @index_page_content)
    create_page(blog_name <> "/_layouts/default.html", @default_layout_content)
    create_page(blog_name <> "/_widgets/recent_posts.html", @recent_posts_content)
    create_page(blog_name <> "/_widgets/top_menu.html", @top_menu_content)
    create_page(blog_name <> "/_assets/stylesheets/style.css", @stylesheet_content)
    create_page(blog_name <> "/_widgets/stylesheets.html", @stylesheet_widget_content)
    create_page(blog_name <> "/_sources/the_very_first_post.html", @first_post_content)
  end

  def create_dir(dir_name) do
    File.mkdir_p(dir_name)
  end

  def create_page(path, content) do
    File.write(path, content)
  end

end