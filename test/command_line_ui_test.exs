defmodule CommandLineUITest do
  use ExUnit.Case
  import CommandLineUI

  describe "get_input/3" do
    test "when passed a context and invalid input nil, returns a context with input '!'" do
      example_context = %{
        prompt:
          "I didn't understand that and I don't know what to do. Please enter a valid command.",
        view: :welcome,
        input: nil
      }

      updated_context = get_input(example_context, FakeIO)

      assert %{input: :invalid_input} = updated_context
    end
  end

  describe "refresh_display/1" do
    test "clears the screen, prepares the next screen, outputs it to IO and leaves the context map unchanged" do
      initial_context = %{
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = refresh_display(initial_context, FakeIO)

      assert initial_context = updated_context
    end
  end

  describe "sanitize_input/1" do
    test "when passed nil, returns :invalid_input" do
      expected_output = :invalid_input
      output = sanitize_input(nil, FakeIO)

      assert output == expected_output
    end

    test "when passed a valid command, no matter how cased, returns an atom of that command" do
      expected_output = :index

      upcased_input = "I"
      downcased_input = "i"
      spelled_out_input = "index"
      weirdly_cased_input = "iNdEx"

      output_1 = sanitize_input(upcased_input, FakeIO)
      output_2 = sanitize_input(downcased_input, FakeIO)
      output_3 = sanitize_input(spelled_out_input, FakeIO)
      output_4 = sanitize_input(weirdly_cased_input, FakeIO)

      assert output_1 == expected_output
      assert output_2 == expected_output
      assert output_3 == expected_output
      assert output_4 == expected_output
    end

    test "when passed an invalid command, returns :invalid_input" do
      expected_output = :invalid_input

      invalid_char_input = "!"
      empty_input = "     \n \n"
      no_recipe_there_input = "89"
      misspelled_input = "idnex"

      output_1 = sanitize_input(invalid_char_input, FakeIO)
      output_2 = sanitize_input(empty_input, FakeIO)
      output_3 = sanitize_input(no_recipe_there_input, FakeIO)
      output_4 = sanitize_input(misspelled_input, FakeIO)

      assert output_1 == expected_output
      assert output_2 == expected_output
      assert output_3 == expected_output
      assert output_4 == expected_output
    end

    test "when passed a recipe string or number, returns the index of that recipe" do
      expected_output = "2"

      number_input = "2"
      downcased_input = "black bean soup"
      upcased_input = "Black Bean Soup"
      weirdly_cased_input = "    BLaCk BeAN soUp    "

      output_1 = sanitize_input(number_input, FakeIO)
      output_2 = sanitize_input(downcased_input, FakeIO)
      output_3 = sanitize_input(upcased_input, FakeIO)
      output_4 = sanitize_input(weirdly_cased_input, FakeIO)

      assert output_1 == expected_output
      assert output_2 == expected_output
      assert output_3 == expected_output
      assert output_4 == expected_output
    end

    test "when passed an invalid recipe string, returns the index of that recipe" do
      expected_output = :invalid_input

      no_recipe_there_number = "75"
      no_recipe_there_string = "ice cubes"
      misspelled_input = "BBBLAAACK BEANS!!!"
      empty_input = "  \n "

      output_1 = sanitize_input(no_recipe_there_number, FakeIO)
      output_2 = sanitize_input(no_recipe_there_string, FakeIO)
      output_3 = sanitize_input(misspelled_input, FakeIO)
      output_4 = sanitize_input(empty_input, FakeIO)

      assert output_1 == expected_output
      assert output_2 == expected_output
      assert output_3 == expected_output
      assert output_4 == expected_output
    end
  end
end
