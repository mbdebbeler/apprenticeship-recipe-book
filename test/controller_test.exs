defmodule ControllerTest do
  use ExUnit.Case
  import Controller

  describe "main/1" do
    test "prints a welcome message" do
      assert(fn -> main("") end) == {:ok, "Welcome to Recipe Book!\n"}
    end
  end

  describe "run/1" do
    test "when passed an atom, prints a message" do
      assert(fn -> run(:owls) end) == {:ok, "The owls are not what they seem.\n"}
    end

    test "when passed 'Q', prints a quit message and exits the program." do
      assert(fn -> run("Q") end) == {:ok, "Goodbye!.\n"}
    end

  end

end
