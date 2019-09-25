defmodule DisplayRecipe.CLI do
  @outgoing_messages %{
    :welcome_screen => "Welcome to Recipe Book!"
  }

  def main(_args) do
    print(@outgoing_messages[:welcome_screen])
  end

  def print(text) do
    IO.puts(text)
  end

  def read_file(filepath) do
    File.read!(filepath)
  end

end
