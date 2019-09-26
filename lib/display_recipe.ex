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

  def split_file_by_lines(recipe) do
    recipe
    |> String.split("\n")
  end

  def find_ingredients(recipe_lines) do
    find_ingredients(recipe_lines, [], false)
  end

  def find_ingredients([recipe_line | remaining_lines], ingredients_list, collect) do
    case recipe_line do
      "Ingredients:" ->
        find_ingredients(remaining_lines, ingredients_list, true)

      _ ->
        find_ingredients(remaining_lines, ingredients_list, collect)
    end
  end

  def find_ingredients([], ingredients_list, _), do: ingredients_list
end
