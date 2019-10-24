defmodule RecipeParser do
  def read_file(nil), do: Messages.get_prompt(:not_found)

  def read_file(filepath) do
    File.read!(Path.expand(filepath))
  end

  def generate_recipe_map do
    filepath = "./recipes/*.txt"
    recipe_files = fetch_list_of_recipe_files(filepath)
    recipe_names = parse_list_of_recipe_names(filepath)
    Enum.zip(recipe_names, recipe_files) |> Enum.into(%{})
  end

  def fetch_list_of_recipe_files(filepath) do
    Path.wildcard(filepath)
  end

  def parse_list_of_recipe_names(filepath) do
    filepath
    |> fetch_list_of_recipe_files
    |> Enum.map(fn x -> Path.basename(x, ".txt") end)
    |> Enum.map(fn x -> Regex.replace(~r/_/, x, " ") end)
    |> Enum.map(fn x -> capitalize_per_word(x) end)
  end

  defp capitalize_per_word(string) do
    String.split(string)
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def parse_grocery_list(filepath) do
    filepath
    |> read_file
    |> split_file_by_lines
    |> is_after_ingredients
    |> is_before_section_break
    |> generate_bulleted_list
  end

  def generate_bulleted_list(items) do
    items
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
  end

  def change_servings(%{input: input, content: content} = context) do
    updated_servings = transform_ingredients_chunk(content, input)

    %{context | content: updated_servings, last_input: input}
  end

  def transform_ingredients_chunk(content, desired_servings) do
    Enum.map(content, fn line ->
      line
      |> split_line_by_words
      |> transform_line(String.to_integer(desired_servings))
      |> join_line_by_words
    end)
  end

  def split_file_by_lines(recipe) do
    recipe
    |> String.split("\n")
  end

  def split_line_by_words(line) do
    line
    |> String.split(" ")
  end

  def join_line_by_words(word_list) do
    word_list
    |> Enum.join(" ")
  end

  def is_after_ingredients(recipe_lines) do
    is_after_ingredients(recipe_lines, [])
  end

  def is_after_ingredients([recipe_line | remaining_lines], ingredients_list) do
    case recipe_line do
      "INGREDIENTS" ->
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

  def transform_line(split_line, desired_servings) do
    transformed_line = []

    Enum.map(split_line, fn word ->
      if is_valid_quantity(word) do
        new_quantity = multiply_servings(word, desired_servings)
        transformed_line ++ Integer.to_string(new_quantity)
      else
        transformed_line ++ word
      end
    end)
  end

  def multiply_servings(word, desired_servings) do
    String.to_integer(word) * desired_servings
  end

  def is_valid_quantity(str) do
    case Integer.parse(str) do
      {num, ""} ->
        if num > 0 do
          true
        else
          false
        end

      _ ->
        false
    end
  end
end
