defmodule RecipeParser do
  
  def read_file(nil), do: Messages.get_prompt(:not_found)

  def read_file(filepath) do
    File.read!(Path.expand(filepath))
  end

  def parse_tokens(filepath) do
    tokens =
      read_file(filepath)
      |> Parser.lex()

    title = parse_title(tokens)
    servings = parse_servings(tokens)
    directions = parse_directions(tokens)
    ingredients = parse_ingredients(tokens)

    %Recipe{title: title, servings: servings, directions: directions, ingredients: ingredients}
  end

  def parse_title(tokens) do
    target_line = 1

    tokens
    |> filter_tokens_by_line(target_line)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> unwrap()
    |> Enum.join()
  end

  def parse_servings(tokens) do
    target_line = 2

    tokens
    |> filter_tokens_by_line(target_line)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> filter_tokens_for_integers_and_fractions()
    |> unwrap()
    |> set_max_and_min()
  end

  def parse_ingredients(tokens) do
    range = tokens |> find_ingredients_range()

    tokens
    |> filter_tokens_by_range(range)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> chunk_by_same_line()
    |> join_each_line()
  end

  def parse_directions(tokens) do
    range = tokens |> find_directions_range()

    tokens
    |> filter_tokens_by_range(range)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> reject_integers()
    |> chunk_by_same_line()
    |> join_each_line()
    |> map_each_direction()
    |> check_display_index()
  end

  defp check_display_index(direction_list) do
    Enum.map(direction_list, fn(direction_map) ->
        correct_first_display_index(direction_map)
    end)
  end

  defp correct_first_display_index(%{direction: _direction, display_index: 0} = direction) do
    Map.put(direction, :display_index, "Before you start: ")
  end

  defp correct_first_display_index(direction) do
    direction
  end

  defp map_each_direction(direction_list) do
    direction_list
    |> Enum.with_index()
    |> Enum.map(fn({direction, index}) ->
      %{direction: direction, display_index: index}
     end)
  end

  defp join_each_line(token_list) do
    Enum.map(token_list, fn(token) -> Enum.join(unwrap(token)) end)
  end

  defp chunk_by_same_line(tokens) do
    Enum.chunk_by(tokens, fn{_token, line, _value} -> line end)
  end

  defp find_directions_range(tokens) do
    first_line = tokens |> filter_section_starts() |> filter_directions_header |> get_line_number
    last_line = [List.last(tokens)] |> get_line_number
    [first_line+1, last_line]
  end

  defp find_ingredients_range(tokens) do
    first_line = tokens |> filter_section_starts() |> filter_ingredients_header |> get_line_number
    last_line = tokens |> filter_section_starts() |> filter_directions_header |> get_line_number
    [first_line+1, last_line-1]
  end

  defp filter_section_starts(tokens) do
    Enum.filter(tokens, fn {token, _line, _value} -> :section_start == token end)
  end

  defp filter_directions_header(tokens) do
    Enum.filter(tokens, fn {_token, _line, value} -> 'BEFORE' == value end)
  end

  defp filter_ingredients_header(tokens) do
    Enum.filter(tokens, fn {_token, _line, value} -> 'INGREDIENTS' == value end)
  end

  defp filter_tokens_for_integers_and_fractions(tokens) do
    Enum.filter(tokens, fn {token, _line, _value} -> :int == token || :fraction == token end)
  end

  defp filter_tokens_by_line(tokens, target_line) do
    Enum.filter(tokens, fn {_token, line, _value} -> line == target_line end)
  end

  defp filter_tokens_by_range(tokens, [first_line, last_line]) do
    Enum.filter(tokens, fn {_token, line, _value} ->  first_line <= line && line <= last_line end)
  end

  defp reject_integers(tokens) do
    Enum.reject(tokens, fn {token, _line, _value} -> :int == token end)
  end

  defp get_line_number([{_token, line, _value}]) do
    line
  end

  defp trim_newlines(tokens) do
    Enum.reject(tokens, fn {token, _line, _value} -> token == :new_line end)
  end

  defp trim_section_start(tokens) do
    Enum.reject(tokens, fn {token, _line, _value} -> token == :section_start end)
  end

  defp trim_section_end(tokens) do
    Enum.reject(tokens, fn {token, _line, _value} -> token == :section_end end)
  end

  defp unwrap(tokens) do
    Enum.map(tokens, fn {_token, _line, value} -> value end)
  end

  defp set_max_and_min(list) do
    %{min: Enum.min(list), max: Enum.max(list)}
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
