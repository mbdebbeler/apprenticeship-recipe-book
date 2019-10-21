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

      output = bulleted_list(example_ingredients)

      assert output == expected_output
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

      output = numbered_list(example_ingredients)

      assert output == expected_output
    end
  end

  describe "print_screen/1" do
    test "takes a context map, returns an unchanged context map and a message to print" do
      initial_context = %{
        input: :welcome,
        header: nil,
        content: nil,
        view: :welcome,
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil
      }

      updated_context = print_screen(initial_context)

      assert %{view: :welcome} = updated_context
    end
  end

end
