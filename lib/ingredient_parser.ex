defmodule IngredientParser do
  require WordToNumber

  def find_quantity(ingredient_data, recipe_line) do
    quantity =
      recipe_line
      |> downcase_line
      |> split_line_by_words
      |> handle_word_numbers
      |> handle_indefinite_articles
      |> drop_non_quantities

    %Ingredient{ingredient_data | quantity: quantity}
  end

  defp split_line_by_words(line) do
    line
    |> String.split(" ")
  end

  defp handle_indefinite_articles(word_list) do
    list = Enum.to_list(word_list)
    first_item = List.first(list)

    if is_integer(first_item) do
      word_list
    else
      WordToNumber.convert_indefinite(word_list)
    end
  end

  defp handle_word_numbers(word_list) do
    Enum.map(word_list, fn x -> WordToNumber.convert(x) end)
  end

  defp drop_non_quantities(word_list) do
    case Enum.fetch(word_list, 0) do
      {:ok, x} -> x
      :error -> nil
    end
  end

  defp downcase_line(recipe_line) do
    String.downcase(recipe_line)
  end

  def is_numeric(str) do
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
