defmodule Blixir.CLI do

  @moduledoc """
  Handle the command line parsing and the call to run the application.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  `argv` can also be new and name of your blog.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], 
                                            aliases: [h: :help])

    case parse do
      {[help: true], _, _}
        -> :help
      {_, [ new, blog_name ] , _}
        -> { new, blog_name }
      {_, [ build ] , _}
        -> { build }
    end
  end

  @doc """
  process to handle the help switch.
  """

  def process(:help) do 
    IO.puts """
    blixir new <blog_name> #creates a new blog
    blixir build           #builds your blog
    """
    System.halt(0)
  end

  @doc """
  process to handle the new switch.
  """

  def process({new, blog_name}) do
    Blixir.CreateBlog.process({new, blog_name})
  end

  @doc """
  process to handle the build switch.
  """

  def process({build}) do
    Blixir.BuildBlog.process
  end

end
