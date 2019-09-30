defmodule ControllerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Controller

  test "main prints a welcome message" do
    assert capture_io(fn -> main("") end) == "Welcome to Recipe Book!\n"
  end
end
