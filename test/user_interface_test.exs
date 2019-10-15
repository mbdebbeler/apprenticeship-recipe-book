defmodule UserInterfaceTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import UserInterface

  describe "get_input/3" do
    test "when passed a context and valid IO input 'y', returns a context with input 'Y'" do
      example_context = %{
        prompt: "Fake Prompt Message",
        io: FakeIO,
        view: :welcome,
        input: "tango"
      }

      updated_context = get_input(example_context)

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

  describe "display/1" do
    test "prints provided message to the console" do
      example_message = "Foo Bar"

      response = fn ->
        assert example_message |> display() == :ok
      end

      output = capture_io(response)
      expected_output = example_message <> "\n"

      assert output == expected_output
    end
  end

  describe "line_break/0" do
    test "adds two newlines" do
      line_break = fn ->
        assert line_break() == :ok
      end

      output = capture_io(line_break)
      expected_output = "\n\n"

      assert output == expected_output
    end
  end
end
