defmodule WordToNumberTest do
  use ExUnit.Case
  import WordToNumber

  describe "convert/1" do
    test "converts a string English word reprenting a number 1-20 to an integer" do
      word = "four"
      expected_number = 4
      number = convert(word)

      assert number == expected_number
    end

    test "returns a word if it isn't a number" do
      word = "octopus"
      expected_output = "octopus"
      output = convert(word)

      assert output == expected_output
    end
  end

  describe "convert_indefinite/1" do
    test "converts 'a dozen' into 12" do
      word_list = ["a", "dozen", "apples"]
      output = convert_indefinite(word_list)
      expected_output = [12, ["apples"]]

      assert output == expected_output
    end
  end
end
