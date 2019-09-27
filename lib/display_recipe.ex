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
    find_ingredients(recipe_lines, [])
  end

  def find_ingredients([recipe_line | remaining_lines], ingredients_list) do
    case recipe_line do
      "Ingredients:" ->
        is_before_next_section(remaining_lines)

      _ ->
        find_ingredients(remaining_lines, ingredients_list)
    end
  end

  def find_ingredients([], ingredients_list), do: ingredients_list

  def is_before_next_section(remaining_lines) do
    is_before_next_section(remaining_lines, [])
  end

  def is_before_next_section([recipe_line | remaining_lines], instruction_list) do
    print remaining_lines
    print recipe_line
    case recipe_line do
      "bab" ->
        print ~s(I am bab: #{recipe_line})

      _ ->
        is_before_next_section(remaining_lines, instruction_list)

    end
  end

  def is_before_next_section([], instruction_list), do: instruction_list

end
