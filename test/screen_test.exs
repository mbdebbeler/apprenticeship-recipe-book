defmodule ScreenTest do
  use ExUnit.Case
  import Screen

  describe "build/0" do
    test "returns a struct with view :welcome and an appropriate prompt" do
      blank_screen = %Screen{
        menu: nil,
        user_input: nil,
        current_view: :welcome,
        prompt: "Welcome to Recipe Book!"
      }

      assert build() == blank_screen
    end
  end

  describe "build/2" do
    test "takes a screen and user input, returns a struct with view :welcome and an appropriate prompt" do
      blank_screen = %Screen{
        menu: nil,
        user_input: nil,
        current_view: :welcome,
        prompt: "Welcome to Recipe Book!"
      }

      welcome_screen = %Screen{
        current_view: :welcome,
        prompt: nil,
        user_input: "V",
        menu: nil
      }

      assert build("V", blank_screen) == welcome_screen
    end
  end
end
