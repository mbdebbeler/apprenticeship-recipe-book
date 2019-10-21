defmodule CommandLineUITest do
  use ExUnit.Case
  import CommandLineUI

  describe "get_input/3" do
    test "when passed a context and valid IO input 'y', returns a context with input 'Y'" do
      initial_context = %{
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        io: FakeIO,
        prompt: "Fake Prompt Message",
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = get_input(initial_context)

      assert %{input: "Y"} = updated_context
    end

    test "when passed a context and invalid input nil, returns a context with input '!'" do
      example_context = %{
        prompt:
          "I didn't understand that and I don't know what to do. Please enter a valid command.",
        io: FakeIO,
        view: :welcome,
        input: nil
      }

      updated_context = get_input(example_context)

      assert %{input: "!"} = updated_context
    end
  end

  describe "refresh_display/1" do
    test "clears the screen, prepares the next screen, outputs it to IO and leaves the context map unchanged" do
      initial_context = %{
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        io: FakeIO,
        prompt: "Fake Prompt Message",
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = refresh_display(initial_context)

      assert initial_context = updated_context
    end
  end
end
