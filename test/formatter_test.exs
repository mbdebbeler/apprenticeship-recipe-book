defmodule FormatterTest do
  use ExUnit.Case
  import Formatter

  describe "bulleted_list/1" do
    test "when passed a list, it will return a list formatted with dashes and newlines" do
      example_ingredients = [
        "2 cups water (approximately)",
        "2 tablespoons water (additional if needed)"
      ]

      expected_output = [
        "- 2 cups water (approximately)\n",
        "- 2 tablespoons water (additional if needed)\n"
      ]

      assert bulleted_list(example_ingredients) == expected_output
    end
  end

  describe "numbered_list/1" do
    test "when passed a list, it will return a list formatted with dashes and newlines" do
      example_ingredients = [
        "2 cups water (approximately)"
      ]

      expected_output = [
        "1) 2 cups water (approximately)\n"
      ]

      assert numbered_list(example_ingredients) == expected_output
    end
  end
end
