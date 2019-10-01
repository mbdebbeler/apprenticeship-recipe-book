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
end
