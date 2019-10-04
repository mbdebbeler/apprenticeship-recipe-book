defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "parse_input/1" do
    test "when passed a character on the menu, does not error" do
      output = fn -> parse_input("V") end
      assert capture_io(output) == "Which recipe would you like to view?\n- Ice Cubes\n\n"
    end

    test "when passed a character not on the menu, sends an error message" do
      error_prompt =
        "I didn't understand that and I don't know what to do. Please enter a valid command.\n\n\n"

      output = fn -> parse_input("R") end
      assert capture_io(output) == error_prompt
    end
  end

  describe "execute_command/1" do
    test "when passed 'V', prints a list of viewable recipes files" do
      view_recipe_list = "- Ice Cubes\n\n"
      output = fn -> execute_command("V") end
      assert capture_io(output) == view_recipe_list
    end

    test "when passed 'Q', prints the quit message." do
      quit_prompt = "\e[H\e[2J\n\nGoodbye!\n\n\n"
      output = fn -> execute_command("Q") end
      assert capture_io(output) == quit_prompt
    end

    test "when passed 'G', prints a grocery list." do
      grocery_list =
        "- 2 cups water (approximately)\n- 2 tablespoons water (additional if needed)\n\n"

      output = fn -> execute_command("G") end
      assert capture_io(output) == grocery_list
    end

    test "when passed 'I', prints the Ice Cubes recipe." do
      ice_cubes_string =
        "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n\n*** Enter 'G' to generate a grocery list for this recipe! ***\n"

      output = fn -> execute_command("I") end
      assert capture_io(output) == ice_cubes_string
    end

    test "when passed :welcome_screen, prints an empty string." do
      output = fn -> execute_command(:welcome_screen) end
      assert capture_io(output) == ""
    end
  end
end
