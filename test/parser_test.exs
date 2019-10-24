defmodule ParserTest do
  use ExUnit.Case
  import Parser

  describe "simple_lex/1" do
    test "when passed a string of alphanumeric characters, returns a flat list of tokens" do
      recipe_string = "Empty any ice cubes that are left in the trays into the bin"

      output = Parser.simple_lex(recipe_string)
      expected_output = [
              {:word, 1, 'Empty'},
              {:whitespace, 1, ' '},
              {:word, 1, 'any'},
              {:whitespace, 1, ' '},
              {:word, 1, 'ice'},
              {:whitespace, 1, ' '},
              {:word, 1, 'cubes'},
              {:whitespace, 1, ' '},
              {:word, 1, 'that'},
              {:whitespace, 1, ' '},
              {:word, 1, 'are'},
              {:whitespace, 1, ' '},
              {:word, 1, 'left'},
              {:whitespace, 1, ' '},
              {:word, 1, 'in'},
              {:whitespace, 1, ' '},
              {:word, 1, 'the'},
              {:whitespace, 1, ' '},
              {:word, 1, 'trays'},
              {:whitespace, 1, ' '},
              {:word, 1, 'into'},
              {:whitespace, 1, ' '},
              {:word, 1, 'the'},
              {:whitespace, 1, ' '},
              {:word, 1, 'bin'}
            ]

      assert output == expected_output
    end

    test "when passed a string that contains non-alphanumeric characters, returns a flat list of tokens" do
      recipe_string = "Empty @ any ! ice -/@#:;,.'{}()[]&|*"
      output = Parser.simple_lex(recipe_string)
      expected_output = [
              {:word, 1, 'Empty'},
              {:whitespace, 1, ' '},
              {:char, 1, '@'},
              {:whitespace, 1, ' '},
              {:word, 1, 'any'},
              {:whitespace, 1, ' '},
              {:char, 1, '!'},
              {:whitespace, 1, ' '},
              {:word, 1, 'ice'},
              {:whitespace, 1, ' '},
              {:char, 1, '-'},
              {:char, 1, '/'},
              {:char, 1, '@'},
              {:char, 1, '#'},
              {:char, 1, ':'},
              {:char, 1, ';'},
              {:char, 1, ','},
              {:char, 1, '.'},
              {:char, 1, '\''},
              {:char, 1, '{'},
              {:char, 1, '}'},
              {:char, 1, '('},
              {:char, 1, ')'},
              {:char, 1, '['},
              {:char, 1, ']'},
              {:char, 1, '&'},
              {:char, 1, '|'},
              {:char, 1, '*'}
            ]
      assert output == expected_output

    end

    test "handles both newlines and double newlines, labels double newlines as section_end" do
        recipe_string = "2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
        output = Parser.simple_lex(recipe_string)
        expected_output = [
              {:int, 1, 2},
              {:whitespace, 1, ' '},
              {:word, 1, 'cups'},
              {:whitespace, 1, ' '},
              {:word, 1, 'water'},
              {:whitespace, 1, ' '},
              {:char, 1, '('},
              {:word, 1, 'approximately'},
              {:char, 1, ')'},
              {:new_line, 1, '\n'},
              {:int, 2, 2},
              {:whitespace, 2, ' '},
              {:word, 2, 'tablespoons'},
              {:whitespace, 2, ' '},
              {:word, 2, 'water'},
              {:whitespace, 2, ' '},
              {:char, 2, '('},
              {:word, 2, 'additional'},
              {:whitespace, 2, ' '},
              {:word, 2, 'if'},
              {:whitespace, 2, ' '},
              {:word, 2, 'needed'},
              {:char, 2, ')'},
              {:section_end, 2, '\n\n'}
            ]
        assert output == expected_output
    end

    test "handles section_start keywords" do
      recipe_string = "INGREDIENTS\n2 cups water (approximately)\n"
      output = Parser.simple_lex(recipe_string)
      expected_output = {:section_start, 1, 'INGREDIENTS'}
      assert Enum.member?(output, expected_output)
    end

    test "handles whitespace" do
      recipe_string = "2 cups water (approximately)"
      output = Parser.simple_lex(recipe_string)
      expected_output = {:whitespace, 1, ' '}
      assert Enum.member?(output, expected_output)
    end

    test "tokenizes integers" do
      recipe_string = "2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
      output = Parser.simple_lex(recipe_string)
      expected_output = {:int, 2, 2}
      assert Enum.member?(output, expected_output)
    end

    test "tokenizes fractions" do
      recipe_string = "2 1/2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
      output = Parser.simple_lex(recipe_string)
      expected_output = {:fraction, 1, '1/2'}
      assert Enum.member?(output, expected_output)
    end

    test "returns an error indicating the line number when passed an illegal character" do
      recipe_string = "2 ½ cups water (approximately)\n"
      output = Parser.simple_lex(recipe_string)
      assert output == {1, :recipe_lexer, {:illegal, [189]}}
    end

    test "returns and empty list when passed an empty string" do
      recipe_string = ""
      output = Parser.simple_lex(recipe_string)
      expected_output = []
      assert output == expected_output
    end
  end


  describe "lex/1" do
    test "when passed a string of alphanumeric characters, returns a flat list of tokens" do
      recipe_string = "Empty any ice cubes that are left in the trays into the bin"

      output = Parser.lex(recipe_string)
      expected_output = [
              {:word, 1, 'Empty'},
              {:whitespace, 1, ' '},
              {:word, 1, 'any'},
              {:whitespace, 1, ' '},
              {:word, 1, 'ice'},
              {:whitespace, 1, ' '},
              {:word, 1, 'cubes'},
              {:whitespace, 1, ' '},
              {:word, 1, 'that'},
              {:whitespace, 1, ' '},
              {:word, 1, 'are'},
              {:whitespace, 1, ' '},
              {:word, 1, 'left'},
              {:whitespace, 1, ' '},
              {:word, 1, 'in'},
              {:whitespace, 1, ' '},
              {:word, 1, 'the'},
              {:whitespace, 1, ' '},
              {:word, 1, 'trays'},
              {:whitespace, 1, ' '},
              {:word, 1, 'into'},
              {:whitespace, 1, ' '},
              {:word, 1, 'the'},
              {:whitespace, 1, ' '},
              {:word, 1, 'bin'}
            ]

      assert output == expected_output
    end

    test "when passed a string that contains non-alphanumeric characters, returns a flat list of tokens" do
      recipe_string = "Empty @ any ! ice -/@#:;,.'{}()[]&|*"
      output = Parser.lex(recipe_string)
      expected_output = [
              {:word, 1, 'Empty'},
              {:whitespace, 1, ' '},
              {:char, 1, '@'},
              {:whitespace, 1, ' '},
              {:word, 1, 'any'},
              {:whitespace, 1, ' '},
              {:char, 1, '!'},
              {:whitespace, 1, ' '},
              {:word, 1, 'ice'},
              {:whitespace, 1, ' '},
              {:char, 1, '-'},
              {:char, 1, '/'},
              {:char, 1, '@'},
              {:char, 1, '#'},
              {:char, 1, ':'},
              {:char, 1, ';'},
              {:char, 1, ','},
              {:char, 1, '.'},
              {:char, 1, '\''},
              {:char, 1, '{'},
              {:char, 1, '}'},
              {:char, 1, '('},
              {:char, 1, ')'},
              {:char, 1, '['},
              {:char, 1, ']'},
              {:char, 1, '&'},
              {:char, 1, '|'},
              {:char, 1, '*'}
            ]
      assert output == expected_output
    end

    test "handles both newlines and double newlines, labels double newlines as section_end" do
        recipe_string = "2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
        output = Parser.lex(recipe_string)
        expected_output = [
              {:int, 1, 2},
              {:whitespace, 1, ' '},
              {:word, 1, 'cups'},
              {:whitespace, 1, ' '},
              {:word, 1, 'water'},
              {:whitespace, 1, ' '},
              {:char, 1, '('},
              {:word, 1, 'approximately'},
              {:char, 1, ')'},
              {:new_line, 1, '\n'},
              {:int, 2, 2},
              {:whitespace, 2, ' '},
              {:word, 2, 'tablespoons'},
              {:whitespace, 2, ' '},
              {:word, 2, 'water'},
              {:whitespace, 2, ' '},
              {:char, 2, '('},
              {:word, 2, 'additional'},
              {:whitespace, 2, ' '},
              {:word, 2, 'if'},
              {:whitespace, 2, ' '},
              {:word, 2, 'needed'},
              {:char, 2, ')'},
              {:section_end, 2, '\n\n'}
            ]
        assert output == expected_output
    end

    test "handles section_start keywords" do
      recipe_string = "INGREDIENTS\n2 cups water (approximately)\n"
      output = Parser.lex(recipe_string)
      expected_output = {:section_start, 1, 'INGREDIENTS'}
      assert Enum.member?(output, expected_output)
    end

    test "handles whitespace" do
      recipe_string = "2 cups water (approximately)"
      output = Parser.lex(recipe_string)
      expected_output = {:whitespace, 1, ' '}
      assert Enum.member?(output, expected_output)
    end

    test "tokenizes integers" do
      recipe_string = "2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
      output = Parser.lex(recipe_string)
      expected_output = {:int, 2, 2}
      assert Enum.member?(output, expected_output)
    end

    test "tokenizes fractions" do
      recipe_string = "2 1/2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\n"
      output = Parser.lex(recipe_string)
      expected_output = {:fraction, 1, '1/2'}
      assert Enum.member?(output, expected_output)
    end

    test "returns and empty list when passed an empty string" do
      recipe_string = ""
      output = Parser.lex(recipe_string)
      expected_output = []
      assert output == expected_output
    end
  end

  describe "parse/1" do
    test "when passed a string of a .txt recipe file, returns an abstract syntax tree." do
      recipe = RecipeParser.read_file('recipes/esquites.txt')

      output = parse(recipe)

      assert is_list(output)
    end
  end

end