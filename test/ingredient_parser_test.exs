defmodule IngredientParserTest do
  use ExUnit.Case
  import IngredientParser

  describe "find_quantity/1" do
    test "converts words for numbers into numbers" do
      ingredient_data = %Ingredient{}
      recipe_line = "four cups apples"
      assert %{ quantity: 4} = find_quantity(ingredient_data, recipe_line)
    end

    test "is not fooled by Uppercase" do
      ingredient_data = %Ingredient{}
      recipe_line = "Four cups apples"
      assert %{ quantity: 4} = find_quantity(ingredient_data, recipe_line)
    end

    test "converts indefinite articles into numbers" do
      ingredient_data = %Ingredient{}
      recipe_line = "A cup of sugar"
      assert %{ quantity: 1} = find_quantity(ingredient_data, recipe_line)
    end

    test "converts non-number words into numbers" do
      ingredient_data = %Ingredient{}
      recipe_line_dozen = "A dozen eggs"
      recipe_line_couple = "A couple eggs"
      assert %{ quantity: 12} = find_quantity(ingredient_data, recipe_line_dozen)
      assert %{ quantity: 2} = find_quantity(ingredient_data, recipe_line_couple)
    end
  end

end
