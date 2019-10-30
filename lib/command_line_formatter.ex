defmodule CommandLineFormatter do
  def prepare_next_screen(%{
        error: error,
        menu: menu,
        header: header,
        content: %Recipe{} = content
      }) do
    formatted_content =
      content
      |> format_recipe()

    [header, formatted_content, menu, error]
    |> Enum.reject(fn x -> x == nil end)
    |> Enum.join("\n\n")
  end

  def prepare_next_screen(%{error: error, menu: menu, header: header, content: content}) do
    [header, content, menu, error]
    |> Enum.reject(fn x -> x == nil end)
    |> Enum.join("\n")
  end

  def format_recipe(recipe) do
    servings = format_servings(recipe.servings)
    directions = format_directions(recipe.directions)
    ingredients = format_ingredients(recipe.ingredients)

    recipe_string = [
      "#{recipe.title}",
      "Serves: #{servings}",
      "Ingredients:\n#{ingredients}",
      "Directions:\n#{directions}"
    ]

    Enum.join(recipe_string, "\n\n")
  end

  defp format_servings(%{min: nil}) do
    "(see main recipe for servings)"
  end

  defp format_servings(%{min: min, max: max}) do
    if min == max do
      "#{Integer.to_string(min)}"
    else
      "#{Integer.to_string(min)} to #{Integer.to_string(max)}"
    end
  end

  defp format_directions(directions) do
    directions
    |> Enum.map(fn %{display_index: display_index, direction: direction} ->
      "#{display_index}: #{direction}"
    end)
    |> Enum.join("\n")
  end

  defp format_ingredients(ingredients) do
    ingredients
    |> Enum.join("\n")
  end
end
