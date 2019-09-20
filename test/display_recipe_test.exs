defmodule DisplayRecipeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "#print prints a string to stdout" do
    assert capture_io(fn -> DisplayRecipe.CLI.print("Ice Cubes") end) == "Ice Cubes\n"
  end

  test "#main prints a welcome message" do
    assert capture_io(fn -> DisplayRecipe.CLI.main end) == "Welcome to Recipe Book!\n"
  end

  test "#receive_command returns a sanitized string when given valid input" do
    assert capture_io(" tEsT  ", fn -> IO.write DisplayRecipe.CLI.receive_command end) == "test"
  end

  test "#receive_command prints failure message when given invalid input" do
    assert capture_io("/n", fn -> IO.write DisplayRecipe.CLI.receive_command end) == "Invalid command. I don't know what to do."
    assert capture_io("@1234685436!!!!", fn -> IO.write DisplayRecipe.CLI.receive_command end) == "Invalid command. I don't know what to do."
    assert capture_io("               ", fn -> IO.write DisplayRecipe.CLI.receive_command end) == "Invalid command. I don't know what to do."
  end

end
