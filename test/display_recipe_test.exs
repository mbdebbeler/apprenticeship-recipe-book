defmodule DisplayRecipeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "prints a string to stdout" do
    assert capture_io(fn -> DisplayRecipe.print("Ice Cubes") end) == "Ice Cubes\n"
  end
end
