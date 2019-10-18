defmodule RecipeParserTest do
  use ExUnit.Case
  import RecipeParser

  describe "generate_recipe_map/0" do
    output = generate_recipe_map()
    expected_output = %{"Bun Thit Nuong" => "recipes/bun_thit_nuong.txt", "Chicken Enmoladas" => "recipes/chicken_enmoladas.txt", "Classic Pasta" => "recipes/classic_pasta.txt", "Cookies" => "recipes/cookies.txt", "Gua Bao" => "recipes/gua_bao.txt", "Ice Cubes" => "recipes/ice_cubes.txt", "Lu Ro Fan" => "recipes/lu_ro_fan.txt", "Papaya Salad" => "recipes/papaya_salad.txt", "Spanakopita" => "recipes/spanakopita.txt", "Tuscan Ragu" => "recipes/tuscan_ragu.txt"}

    assert output == expected_output
  end

  describe "fetch_list_of_recipe_files/1" do
    test "returns a List of of all the recipes in the recipes file" do
      filepath = "./recipes/*.txt"
      output = fetch_list_of_recipe_files(filepath)
      expected_output = ["recipes/bun_thit_nuong.txt", "recipes/chicken_enmoladas.txt", "recipes/classic_pasta.txt", "recipes/cookies.txt", "recipes/gua_bao.txt", "recipes/ice_cubes.txt", "recipes/lu_ro_fan.txt", "recipes/papaya_salad.txt", "recipes/spanakopita.txt", "recipes/tuscan_ragu.txt"]

      assert output == expected_output
    end
  end

  describe "parse_list_of_recipe_names/1" do
    test "returns a list of file names formatted as capitalized English titles" do
      filepath = "./recipes/*.txt"
      output = parse_list_of_recipe_names(filepath)
      expected_output = ["Bun Thit Nuong", "Chicken Enmoladas", "Classic Pasta", "Cookies", "Gua Bao", "Ice Cubes", "Lu Ro Fan", "Papaya Salad", "Spanakopita", "Tuscan Ragu"]

      assert output == expected_output
    end
  end

  describe "read_file/1" do
    test "accepts string filepath and returns string of file contents" do
      filepath = './recipes/ice_cubes.txt'

      expected_output =
        "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"

      output = read_file(filepath)

      assert output == expected_output
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

  describe "is_valid_quantity/1" do
    test "returns true when passed a string that respresents an integer" do
      string_four = "4"

      assert is_valid_quantity(string_four) == true
    end

    test "returns false when passed -1" do
      string_neg_one = "-1"

      assert is_valid_quantity(string_neg_one) == false
    end

    test "returns false when passed 0" do
      string_zero = "0"

      assert is_valid_quantity(string_zero) == false
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
