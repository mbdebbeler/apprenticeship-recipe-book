defmodule DisplayRecipeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "#print prints a string to stdout" do
    assert capture_io(fn -> DisplayRecipe.CLI.print("Ice Cubes") end) == "Ice Cubes\n"
  end

  test "#main prints a welcome message" do
    assert capture_io(fn -> DisplayRecipe.CLI.main end) == "Welcome to Recipe Book!\n"
  end
end
