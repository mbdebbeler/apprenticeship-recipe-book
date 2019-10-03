defmodule ControllerTest do
  use ExUnit.Case
  import Controller

  describe "parse_input/1" do
    test "when passed 'V', returns a list of recipes files" do
      example_recipe_list = ['./recipes/ice_cubes.txt']
      assert parse_input("V") == example_recipe_list
    end

    test "when passed 'Q', returns the quit message." do
      assert parse_input("Q") == "Goodbye!"
    end
  end
end
