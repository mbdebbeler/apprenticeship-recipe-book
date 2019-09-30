defmodule FormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Formatter

  describe "print/1" do
    test "print prints a string to stdout" do
      assert capture_io(fn -> print("Ice Cubes") end) == "Ice Cubes\n"
    end
  end

  describe "pretty_print_list" do
    test "when passed a filepath, it will print a formatted list of the file contents designated as ingredients" do
      example_message = "Groceries for this recipe:"
      example_ingredients = ["- 2 cups water (approximately)", "- 2 tablespoons water (additional if needed)"]
      expected_output = "Groceries for this recipe:\n- 2 cups water (approximately)\n- 2 tablespoons water (additional if needed)\n"

      assert capture_io(fn -> pretty_print_list(example_message, example_ingredients) end) == expected_output
    end
  end

end
