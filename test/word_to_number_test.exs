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

    test "returns nil if the word isn't a number" do
      word = "octopus"
      expected_output = nil
      output = convert(word)

      assert output == expected_output
    end

    test "handles capitalized and lowercased words" do
      word = "Five"
      expected_output = 5
      output = convert(word)

      assert output == expected_output
    end
  end

end
