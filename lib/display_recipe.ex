defmodule DisplayRecipe.CLI do
  @user_prompts %{
    :welcome_screen => "Welcome to Recipe Book!"
  }

  @recipe_files %{
    :ice_cubes => "../recipes/ice_cubes.txt"
  }

  def main(_args) do
    print(@user_prompts[:welcome_screen])
  end

  def print(text) do
    IO.puts(text)
  end

  def read_file(filepath) do
    File.read!(filepath)
  end

  def print_file_contents do
    print(read_file(@recipe_files[:ice_cubes]))
  end 

  def print_file_contents(filepath) do
    print(read_file(filepath))
  end

end

DisplayRecipe.CLI.main
