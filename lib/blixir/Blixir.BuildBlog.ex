defmodule Blixir.BuildBlog do

  @moduledoc """
  Handle the build of a blog.
  """

  @doc """
  Build a blog
  """
  def process do
    IO.puts "Building....."
    build_assets
    IO.puts "Done....."
  end

  @doc """
  Move assets from root directory to _build/assets/
  """

  def build_assets do
    File.mkdir_p("_build/assets/")
    File.copy("_assets/*", "_build/assets/")
  end

end
