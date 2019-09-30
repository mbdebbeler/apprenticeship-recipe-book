defmodule UserInterfaceTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import UserInterface

  describe "get_input/3" do
    test "using FakeIO module in TestHelper, accepts valid input 'j' and returns a capitalized string 'J'" do
      output = fn -> get_input("Fake Prompt Message", FakeIO) |> IO.write() end
      assert capture_io(output) == "J"
    end

    test "user is prompted to try again if they enter an invalid response" do
      output = fn -> get_input(nil, FakeIO) |> IO.write() end
      assert capture_io(output) == "I am asking for your input, user.\n"
    end
  end
end
