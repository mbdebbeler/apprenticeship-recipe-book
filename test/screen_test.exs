defmodule ScreenTest do
  use ExUnit.Case
  import Screen

  describe "build/0" do
    test "returns a struct with view :welcome and an appropriate prompt" do
      welcome_screen = %Screen{
        menu: nil,
        user_input: nil,
        current_view: :welcome,
        prompt: "Welcome to Recipe Book!"
      }

      assert build() == welcome_screen
    end
  end

  describe "build/2" do
    test "takes a screen and user input, returns a struct with view :welcome and an appropriate prompt" do
      welcome_screen = %Screen{
        menu: nil,
        user_input: nil,
        current_view: :welcome,
        prompt: "Welcome to Recipe Book!"
      }

      view_index_screen = %Screen{
        current_view: nil,
        prompt: "Which recipe would you like to view?",
        user_input: "V",
        menu: nil
      }

      assert build("V", welcome_screen) == view_index_screen
    end
  end
end
