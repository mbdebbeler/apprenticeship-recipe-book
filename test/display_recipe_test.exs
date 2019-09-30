defmodule DisplayRecipeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import DisplayRecipe.CLI

  test "print prints a string to stdout" do
    assert capture_io(fn -> DisplayRecipe.CLI.print("Ice Cubes") end) == "Ice Cubes\n"
  end

  test "main prints a welcome message" do
    assert capture_io(fn -> DisplayRecipe.CLI.main("") end) == "Welcome to Recipe Book!\n"
  end

  describe "read_file/1" do
    test "accepts string filepath and returns string of file contents" do
      example_filepath = './recipes/ice_cubes.txt'

      assert read_file(example_filepath) ==
               "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"
    end
  end

  describe "print_file_contents/0" do
    test "prints a string of a hardcoded filepath's contents" do
      assert capture_io(fn -> print_file_contents() end) ==
               "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n" <>
                 "\n"
    end
  end

  describe "print_file_contents/1" do
    test "accepts string relative filepath and prints string of file contents" do
      example_filepath = './recipes/ice_cubes.txt'

      assert capture_io(fn -> print_file_contents(example_filepath) end) ==
               "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n" <>
                 "\n"
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

  describe "is_before_section_break" do
    test "when passed a list of strings, it will return a sub-list of strings before the blank line" do
      example_recipe_chunk = ["baz", "zab", "", "Recipes:", "bab"]

      assert is_before_section_break(example_recipe_chunk) == ["baz", "zab"]
    end
  end

  describe "print_grocery_list" do
    test "when passed a filepath, it will print a formatted list of the file contents designated as ingredients" do
      example_filepath = './recipes/ice_cubes.txt'
      expected_output = "Groceries for this recipe:\n- 2 cups water (approximately)\n- 2 tablespoons water (additional if needed)\n"

      assert capture_io(fn -> print_grocery_list(example_filepath) end) == expected_output
    end
  end
end
