defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "welcome_user()" do
    test "when app opens, a welcome screen is displayed" do
      expected_output = "Welcome to Recipe Book!\n"
      output = fn -> welcome_user() end
      assert capture_io(output) == expected_output
    end
  end

  describe "main/1" do
    test "takes no arguments and returns a map of context" do
      example_context = %{
        input: :welcome,
        content: nil,
        view: :welcome,
        io: IO,
        prompt: Messages.get_prompt(:view),
        menu: Messages.get_menu(:view)
      }

      assert main("") == example_context
    end
  end

  describe "run/1" do
    test "takes a context map and returns a transformed context map" do
    end
  end

  describe "execute_command/1" do
    test "when passed 'I', prints a list of viewable recipes files" do
      example_context = %{
        prompt: "What would you like to do?\n",
        view: :welcome,
        menu: "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
        input: "I"
      }

      assert %{view: :index} = execute_command(example_context)
    end

    test "when passed 'Q', prints the quit message and leaves the context map unchanged." do
      quit_prompt = "Goodbye!\n"
      output = fn -> execute_command(%{input: "Q"}) end
      assert capture_io(output) == quit_prompt

      example_context = %{
        prompt: "What would you like to do?\n",
        view: :welcome,
        menu: "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
        input: "Q"
      }

      assert example_context == execute_command(example_context)
    end

    test "when passed 'G' after viewing a recipe, returns a context with view :grocery_list" do
      example_context = %{
        prompt: "What would you like to do?\n",
        view: :view_recipe,
        content: "1",
        menu: "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
        input: "G"
      }

      assert %{view: :grocery_list} = execute_command(example_context)
    end

    test "when passed a non-integer string not on the menu, prints a a generic error message and does not change the context" do
      error_prompt =
        "\nI didn't understand that and I don't know what to do. Please enter a valid command.\n"

      output = fn -> execute_command(%{input: "R"}) end
      assert capture_io(output) == error_prompt

      example_context = %{
        prompt: "What would you like to do?\n",
        view: :welcome,
        content: "1",
        menu: "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
        input: "R"
      }

      assert %{view: :welcome} = execute_command(example_context)
    end

    test "when passed the number of a listed recipe in view :index, returns a context with that number stored in :content." do
      ice_cubes_string =
        "\nTitle:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n\n"

      example_context = %{
        prompt: "Type the number of the recipe you would like to view.\n",
        view: :index,
        content: nil,
        menu: "Menu Options:\n(1-9) = View a Specific Recipe\nQ = Quit\n\n",
        input: "1"
      }

      output = fn -> execute_command(example_context) end
      assert capture_io(output) == ice_cubes_string
      assert %{view: :recipe} = execute_command(example_context)
    end

    test "when passed a number that does not correspond to an existing recipe in view :index, it prints a Not Found error and does not change the context." do
      not_found =
        "\nWe either don't have that recipe or I can't find it. \n:(. \nPlease choose another recipe.\n"

      example_context = %{
        prompt: "Type the number of the recipe you would like to view.\n",
        view: :index,
        menu: "Menu Options:\n(1-9) = View a Specific Recipe\nQ = Quit\n\n",
        content: nil,
        input: "7"
      }

      output = fn -> execute_command(example_context) end
      assert capture_io(output) == not_found
      assert %{view: :index} = execute_command(example_context)
    end
  end
end
