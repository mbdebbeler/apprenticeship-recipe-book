defmodule UserInterfaceTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import UserInterface

  describe "get_input/3" do
    test "when passed valid IO input 'y', returns capitalized string 'Y'" do
      output = fn -> get_input("Fake Prompt Message") |> IO.write() end
      assert capture_io([input: "n", capture_prompt: false], output) == "N"
    end

    test "when passed invalid IO input nil, returns a string error message" do
      output = fn -> get_input(nil, "Message", FakeIO) |> IO.write() end
      assert capture_io(output) =~ "!"
    end
  end

  describe "display/1" do
    test "prints provided message to the console" do
      example_message = "Foo Bar"

      response = fn ->
        assert example_message |> display() == :ok
      end

      assert capture_io(response) == example_message <> "\n"
    end
  end

  describe "line_break/1" do
    test "adds two newlines" do

      line_break = fn ->
        assert line_break(:ok) == :ok
      end

      assert capture_io(line_break) == "\n\n"
    end
  end
end
