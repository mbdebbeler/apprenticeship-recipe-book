defmodule RecipeParserTest do
  use ExUnit.Case
  import RecipeParser

  describe "read_file/1" do
    test "accepts string filepath and returns string of file contents" do
      example_filepath = './recipes/ice_cubes.txt'

      assert read_file(example_filepath) ==
               "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"
    end
  end

  describe "split_file_by_lines/1" do
    test "when passed a string of file contents, it splits the string by newlines and returns an list of strings" do
      example_recipe_chunk = "foo\nbar\nbaz"

      assert split_file_by_lines(example_recipe_chunk) == ["foo", "bar", "baz"]
    end
  end

  describe "is_after_ingredients/1" do
    test "when passed a list of strings, it will return a sub-list of strings between 'ingredients' and a blank line" do
      example_recipe_chunk = [
        "foo",
        "bar",
        "",
        "Ingredients:",
        "baz",
        "zab",
        "",
        "Recipes:",
        "bab"
      ]

      assert is_after_ingredients(example_recipe_chunk) == ["baz", "zab", "", "Recipes:", "bab"]
    end
  end

  describe "is_before_section_break/1" do
    test "when passed a list of strings, it will return a sub-list of strings before the blank line" do
      example_recipe_chunk = ["baz", "zab", "", "Recipes:", "bab"]

      assert is_before_section_break(example_recipe_chunk) == ["baz", "zab"]
    end
  end

  describe "split_line_by_words/1" do
    test "when passed a string, splits it by spaces" do
      ingredients_line = "4 large dried New Mexico or guajillo chiles, stemmed, halved, seeded"

      split_ingredients_line = [
        "4",
        "large",
        "dried",
        "New",
        "Mexico",
        "or",
        "guajillo",
        "chiles,",
        "stemmed,",
        "halved,",
        "seeded"
      ]

      result = split_line_by_words(ingredients_line)

      assert result == split_ingredients_line
    end
  end

  describe "transform_line/2" do
    test "when passed a list of strings and desired_servings, filters and multiplies integers by desired_servings, returns a list of strings" do
      split_ingredients_line = [
        "4",
        "large",
        "dried",
        "New",
        "Mexico",
        "or",
        "guajillo",
        "chiles,",
        "stemmed,",
        "halved,",
        "seeded"
      ]

      processed_ingredients_line = [
        "8",
        "large",
        "dried",
        "New",
        "Mexico",
        "or",
        "guajillo",
        "chiles,",
        "stemmed,",
        "halved,",
        "seeded"
      ]

      desired_servings = 2

      assert transform_line(split_ingredients_line, desired_servings) ==
               processed_ingredients_line
    end
  end

  describe "is_quantity/1" do
    test "returns true when passed a string that respresents an integer" do
      string_four = "4"

      assert is_quantity(string_four) ==  true
    end
  end

  describe "join_line_by_words/1" do
    test "concatenates a list of strings into one string" do
      ingredients_list = [
        "4",
        "large",
        "dried",
        "New",
        "Mexico",
        "or",
        "guajillo",
        "chiles,",
        "stemmed,",
        "halved,",
        "seeded"
      ]
      ingredients_line = "4 large dried New Mexico or guajillo chiles, stemmed, halved, seeded"

      assert join_line_by_words(ingredients_list) == ingredients_line
    end
  end

  describe "change_servings/1" do
    test "takes a context and returns an updated context" do
      example_context = %{
        input: "3",
        content: ["5 spicy olives", "20 potato chips"],
        header: nil,
        view: :generate_grocery_list,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: "1"
      }
      transformed_context = %{
        input: "3",
        content: ["15 spicy olives", "60 potato chips"],
        header: nil,
        view: :generate_grocery_list,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: "3"
      }

      assert change_servings(example_context) == transformed_context
    end
  end
end
