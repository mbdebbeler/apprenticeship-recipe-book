defmodule Parser do
  def read_file(nil), do: Messages.get_prompt(:not_found)

  def read_file(filepath) do
    File.read!(Path.expand(filepath))
  end

  def parse_tokens(filepath) do
    tokens =
      read_file(filepath)
      |> Lexer.lex()

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
    |> unwrap_values()
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
    |> unwrap_values()
    |> set_max_and_min_servings()
  end

  def parse_ingredients(tokens) do
    range = tokens |> find_ingredients_range()

    tokens
    |> filter_tokens_by_range(range)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> chunk_by_line_number()
    |> join_each_line()
  end

  def new_parse_ingredients(tokens) do
    range = tokens |> find_ingredients_range()

    tokens
    |> filter_tokens_by_range(range)
    |> handle_sub_recipes
  end

  def parse_directions(tokens) do
    range = tokens |> find_directions_range()

    tokens
    |> filter_tokens_by_range(range)
    |> trim_newlines()
    |> trim_section_start()
    |> trim_section_end()
    |> chunk_by_line_number()
    |> trim_single_token_lines()
    |> join_each_line()
    |> map_each_direction()
    |> update_first_direction_display_index()
  end

  def handle_sub_recipes(ingredients_range) do
    if has_sub_recipe?(ingredients_range) do
      ingredients_range
      |> chunk_by_line_number
      |> chunk_by_upcased_lines
      |> Enum.map(fn recipe -> build_recipe_struct(recipe) end)
    else
      ingredients_range
      |> chunk_by_line_number()
      |> Enum.map(fn line -> build_ingredient_struct(line) end)
    end
  end

  def chunk_by_upcased_lines(lines) do
    lines
    |> Enum.chunk_by(fn line ->
      first_token = Enum.fetch!(line, 0)
      {token, _line, _value} = first_token
      token == :upcase_word
    end)
    |> Enum.chunk_every(2)
  end

  def build_recipe_struct(recipe) do
    title =
      recipe
      |> Enum.slice(0, 1)
      |> List.flatten()
      |> unwrap_values
      |> Enum.join()
      |> String.trim()

    ingredients =
      recipe
      |> Enum.slice(1, 1)
      |> Enum.fetch!(0)
      |> Enum.map(fn line -> build_ingredient_struct(line) end)

    %Recipe{title: title, ingredients: ingredients}
  end

  def build_ingredient_struct(line) do
    quantity = pa_quantity(line)
    details = parse_details(line)
    unit = parse_unit(line)
    name = parse_name(line)

    %Ingredient{quantity: quantity, details: details, unit: unit, name: name}
  end

  def parse_details(line) do
    if start_index =
         Enum.find_index(line, fn {token, _line, value} ->
           :char == token && Enum.member?([',', '('], value)
         end) do
      range = start_index..-1

      Enum.slice(line, range)
      |> unwrap_values()
      |> Enum.join()
      |> String.trim(",")
      |> String.trim()
    else
      nil
    end
  end

  def parse_quantity(line) do
    if Enum.find(line, fn {token, _line, _value} -> :int == token || :fraction == token end) do
      handle_mixed_quantities(line)
    else
      nil
    end
  end

  def handle_mixed_quantities(line) do
    end_index =
      Enum.find_index(line, fn {token, _line, _value} ->
        :word == token
      end)

    range = 0..(end_index - 1)

    Enum.slice(line, range)
    |> unwrap_values()
    |> Enum.join()
    |> String.trim(",")
    |> String.trim()
  end

  def parse_unit(line) do
    units = [
      'teaspoon',
      'teaspoons',
      'tablespoon',
      'tablespoons',
      'ounce',
      'ounces',
      'cup',
      'cups',
      'pint',
      'pints',
      'quart',
      'quarts',
      'gallon',
      'gallons',
      'pound',
      'pounds',
      'lb',
      'lbs'
    ]

    if first_word =
         Enum.find(line, fn {token, _line, _value} ->
           :word == token
         end) do
      unit = unwrap_value(first_word)

      if Enum.member?(units, unit) do
        unit
      else
        nil
      end
    else
      nil
    end
  end

  def parse_name(line) do
    name =
      line
      |> reject_details
      |> reject_unit
      |> reject_quantity
      |> unwrap_values
      |> Enum.join()
      |> String.trim()

    if name == "" do
      nil
    else
      name
    end
  end

  def reject_quantity(line) do
    if start_index = Enum.find_index(line, fn {token, _line, _value} -> :word == token end) do
      range = start_index..-1
      Enum.slice(line, range)
    else
      line
    end
  end

  def reject_unit(line) do
    units = [
      'teaspoon',
      'teaspoons',
      'tablespoon',
      'tablespoons',
      'ounce',
      'ounces',
      'cup',
      'cups',
      'pint',
      'pints',
      'quart',
      'quarts',
      'gallon',
      'gallons',
      'pound',
      'pounds',
      'lb',
      'lbs'
    ]

    line
    |> Enum.reject(fn {token, _line, value} ->
      :word == token && Enum.member?(units, value)
    end)
  end

  def reject_details(line) do
    if end_index =
         Enum.find_index(line, fn {token, _line, value} ->
           :char == token && Enum.member?([','], value)
         end) do
      range = 0..(end_index - 1)
      Enum.slice(line, range)
    else
      line
    end
  end

  def has_sub_recipe?(tokens) do
    Enum.any?(tokens, fn {token, _line, _value} -> :upcase_word == token end)
  end

  defp update_first_direction_display_index(direction_list) do
    Enum.map(direction_list, fn direction_map ->
      correct_first_display_index(direction_map)
    end)
  end

  defp correct_first_display_index(%{direction: _direction, display_index: 0} = direction) do
    Map.put(direction, :display_index, "Before you start")
  end

  defp correct_first_display_index(direction) do
    direction
  end

  defp map_each_direction(direction_list) do
    direction_list
    |> Enum.with_index()
    |> Enum.map(fn {direction, index} ->
      %{direction: direction, display_index: index}
    end)
  end

  defp join_each_line(token_list) do
    Enum.map(token_list, fn token -> Enum.join(unwrap_values(token)) end)
  end

  defp chunk_by_line_number(tokens) do
    Enum.chunk_by(tokens, fn {_token, line, _value} -> line end)
  end

  defp find_directions_range(tokens) do
    first_line =
      tokens |> filter_section_starts() |> filter_directions_header |> unwrap_line_number

    last_line = [List.last(tokens)] |> unwrap_line_number
    [first_line + 1, last_line]
  end

  defp find_ingredients_range(tokens) do
    first_line =
      tokens |> filter_section_starts |> filter_ingredients_header |> unwrap_line_number

    last_line = tokens |> filter_section_starts |> filter_directions_header |> unwrap_line_number

    [first_line + 1, last_line - 1]
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
    Enum.filter(tokens, fn {_token, line, _value} -> first_line <= line && line <= last_line end)
  end

  def trim_single_token_lines(lines) do
    Enum.reject(lines, fn line -> Enum.count(line) == 1 end)
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

  defp unwrap_values(tokens) do
    Enum.map(tokens, fn {_token, _line, value} -> value end)
  end

  defp unwrap_value({_token, _line, value}) do
    value
  end

  defp unwrap_line_number([{_token, line, _value}]) do
    line
  end

  defp set_max_and_min_servings(list) do
    if Enum.empty?(list) do
      []
    else
      %{min: Enum.min(list), max: Enum.max(list)}
    end
  end

  def prepare_recipe_index_map do
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
    |> Enum.map(fn x -> capitalize_each_word(x) end)
  end

  defp capitalize_each_word(string) do
    String.split(string)
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def parse_grocery_list(filepath) do
    recipe =
      filepath
      |> parse_tokens()

    generate_bulleted_list(recipe.ingredients)
  end

  def generate_bulleted_list(items) do
    items
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
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
