defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "execute_command/1" do
    test "when passed 'V', prints a list of viewable recipes files" do
      view_recipe_list = "Which recipe would you like to view?\n1) Ice Cubes\n\n"
      output = fn -> execute_command("V") end
      assert capture_io(output) == view_recipe_list
    end

    test "when passed 'Q', prints the quit message." do
      quit_prompt = "Goodbye!\n\n\n"
      output = fn -> execute_command("Q") end
      assert capture_io(output) == quit_prompt
    end

    test "when passed 'G', prints a grocery list." do
      grocery_list =
        "Groceries for this recipe:\n- 2 cups water (approximately)\n- 2 tablespoons water (additional if needed)\n\n"

      output = fn -> execute_command("G") end
      assert capture_io(output) == grocery_list
    end

    test "when passed a non-integer string not on the menu, prints a a generic error message" do
      error_prompt =
        "\nI didn't understand that and I don't know what to do. Please enter a valid command.\n\n\n"

      output = fn -> execute_command("R") end
      assert capture_io(output) == error_prompt
    end

    test "when passed the number of a listed recipe, it prints recipe." do
      ice_cubes_string =
        "\nTitle:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n\n"

      output = fn -> execute_command("1") end
      assert capture_io(output) == ice_cubes_string
    end

    test "when passed a number that does not correspond to an existing recipe, it prints a File Not Found error." do
      not_found =
        "\nWe either don't have that recipe or I can't find it. \n:(. \nPlease choose another recipe.\n"

      output = fn -> execute_command("2") end
      assert capture_io(output) == not_found
    end

    test "when passed :welcome_screen, prints a welcome message." do
      output = fn -> execute_command(:welcome_screen) end
      assert capture_io(output) == "Welcome to Recipe Book!\n"
    end
  end
end
