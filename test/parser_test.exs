defmodule ParserTest do
  use ExUnit.Case
  import Parser

  describe "parse/1" do
    test "when passed a string of a .txt recipe file, returns an abstract syntax tree." do
      recipe = RecipeParser.read_file('recipes/esquites.txt')

      output = parse(recipe)

      assert is_list(output)
    end
  end

end
