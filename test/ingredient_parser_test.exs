defmodule IngredientParserTest do
  use ExUnit.Case
  import IngredientParser

  describe "find_quantity/1" do
    test "converts words for numbers into numbers" do
      ingredient_data = %Ingredient{}
      recipe_line = "Four cups apples"
      assert %{ quantity: 4} = find_quantity(ingredient_data, recipe_line)
    end
  end

end
