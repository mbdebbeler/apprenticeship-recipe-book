defmodule FormatterTest do
  use ExUnit.Case
  import Formatter

  describe "bulleted_list" do
    test "when passed a filepath, it will print a formatted list of the file contents designated as ingredients" do
      example_ingredients = [
        "2 cups water (approximately)",
        "2 tablespoons water (additional if needed)"
      ]

      expected_output = [
        "- 2 cups water (approximately)",
        "- 2 tablespoons water (additional if needed)"
      ]

      assert(fn -> bulleted_list(example_ingredients) == :ok end) == expected_output
    end
  end
end
