defmodule ControllerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Controller

  describe "run/1" do
    test "when passed 'Q', prints a quit message and exits the program." do
      result = fn -> run("Q") end
      assert capture_io([capture_prompt: false], result) == "Goodbye!\n"
    end
  end

  describe "execute_command/1" do
    test "when passed a string that's found in Messages, prints a list of viewable recipes" do
      assert execute_command(:V) == :ok
    end
  end

end
