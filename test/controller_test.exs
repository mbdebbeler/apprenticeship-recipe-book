defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "parse_input/1" do
    test "when passed 'V', returns a list of recipes files" do
      view_recipe_prompt = "Which recipe would you like to view?\n\n\n"
      output = fn -> parse_input("V") end
      assert capture_io(output) == view_recipe_prompt
    end

    test "when passed 'Q', returns the quit message." do
      quit_prompt = "Goodbye!\n\n\n"
      output = fn -> parse_input("Q") end
      assert capture_io(output) == quit_prompt
    end
  end
end
