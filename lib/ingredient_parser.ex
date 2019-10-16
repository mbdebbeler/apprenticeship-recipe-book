defmodule IngredientParser do
  require WordToNumber

  def find_quantity(ingredient_data, recipe_line) do
     word_list = recipe_line
     |> split_line_by_words

     quantity = Enum.map(word_list, fn x -> WordToNumber.convert(x) end)
     |> Enum.reject(fn x -> x == nil end)
     |> Enum.join()
     |> String.to_integer()

     %Ingredient{ingredient_data | quantity: quantity}
  end

  defp split_line_by_words(line) do
    line
    |> String.split(" ")
  end

end
