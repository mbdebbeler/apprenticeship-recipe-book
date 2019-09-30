defmodule DisplayRecipe.CLI do
  @user_prompts %{
    :welcome_screen => "Welcome to Recipe Book!"
  }

  @recipe_files %{
    :ice_cubes => './recipes/ice_cubes.txt'
  }

  def main(_args) do
    print(@user_prompts[:welcome_screen])
  end

  def print(text) do
    IO.puts(text)
  end

  def read_file(filepath) do
    File.read!(Path.expand(filepath))
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

  def is_after_ingredients(recipe_lines) do
    is_after_ingredients(recipe_lines, [])
  end

  def is_after_ingredients([recipe_line | remaining_lines], ingredients_list) do
    case recipe_line do
      "Ingredients:" ->
        remaining_lines

      _ ->
        is_after_ingredients(remaining_lines, ingredients_list)
    end
  end

  def is_after_ingredients([], ingredients_list), do: ingredients_list

  def is_before_section_break(remaining_lines) do
    section_break_index = Enum.find_index(remaining_lines, fn x -> x == "" end)
    Enum.slice(remaining_lines, 0..(section_break_index - 1))
  end

  def print_grocery_list(filepath) do
    print("Groceries for this recipe:")
    filepath
    |> read_file
    |> split_file_by_lines
    |> is_after_ingredients
    |> is_before_section_break
    |> Enum.each(fn x -> print("- " <> x) end)
  end

end
