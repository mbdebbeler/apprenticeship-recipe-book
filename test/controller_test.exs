defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "run/1" do
    test "when passed 'Q', prints the quit message and leaves the context map unchanged." do
      quit_prompt = "\e[H\e[2JGoodbye!\n\n"

      initial_context = %{
        input: "Q",
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        io: IO,
        prompt: "What would you like to do?",
        menu: nil,
        error: nil,
        last_input: nil
      }

      output = fn -> run(initial_context) end

      assert capture_io(output) =~ quit_prompt
    end
  end

  describe "update_context/1" do
    test "when view is :index, updates prompt, header, content and menu" do
      initial_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = update_context(initial_context)

      assert %{prompt: "Which recipe would you like to view? Type the number and press enter.\n"} =
               updated_context

      assert %{header: "Recipe Index:"} = updated_context

      assert %{
               content: [
                 "1) Bun Thit Nuong\n",
                 "2) Chicken Enmoladas\n",
                 "3) Classic Pasta\n",
                 "4) Cookies\n",
                 "5) Gua Bao\n",
                 "6) Ice Cubes\n",
                 "7) Lu Ro Fan\n",
                 "8) Papaya Salad\n",
                 "9) Spanakopita\n",
                 "10) Tuscan Ragu\n"
               ]
             } = updated_context

      assert %{menu: "Menu Options:\n# = View a Specific Recipe\nQ = Quit\n\n"} = updated_context
    end
  end

  describe "fetch_content/1" do
    test "in view :welcome, when passed valid input 'I', changes view to :index and updates content" do
      initial_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :welcome,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Bun Thit Nuong\n",
                 "2) Chicken Enmoladas\n",
                 "3) Classic Pasta\n",
                 "4) Cookies\n",
                 "5) Gua Bao\n",
                 "6) Ice Cubes\n",
                 "7) Lu Ro Fan\n",
                 "8) Papaya Salad\n",
                 "9) Spanakopita\n",
                 "10) Tuscan Ragu\n"
               ]
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :welcome, when passed invalid input 'V', updates error but not view." do
      initial_context = %{
        input: "V",
        content: nil,
        header: nil,
        view: :welcome,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :welcome} = updated_context

      assert %{
               error:
                 "I didn't understand that and I don't know what to do. Please enter a valid command.\n"
             } = updated_context
    end

    test "in view :welcome, when passed valid input :welcome, passes context through unchanged" do
      initial_context = %{
        input: :welcome,
        content: nil,
        header: nil,
        view: :welcome,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert initial_context == updated_context
    end

    test "in view :index, when passed valid input '1', updates content and view" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content:
                 "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"
             } = updated_context

      assert %{view: :view_recipe} = updated_context
    end

    test "in view :index, when passed valid input 'Q', returns nil" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert nil == updated_context
    end

    test "in view :index, when passed invalid input '9', updates error message but not view" do
      initial_context = %{
        input: "46",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               error:
                 "We either don't have that recipe or I can't find it. \n:(. Please choose another recipe.\n"
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :view_recipe, when passed valid input 'G', updates content and view" do
      initial_context = %{
        input: "G",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: IO,
        prompt: nil,
        menu: "Bar",
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "- 2 cups water (approximately)\n",
                 "- 2 tablespoons water (additional if needed)\n"
               ]
             } = updated_context

      assert %{view: :grocery_list} = updated_context
    end

    test "in view :view_recipe, when passed valid input 'I', updates content and view" do
      initial_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Bun Thit Nuong\n",
                 "2) Chicken Enmoladas\n",
                 "3) Classic Pasta\n",
                 "4) Cookies\n",
                 "5) Gua Bao\n",
                 "6) Ice Cubes\n",
                 "7) Lu Ro Fan\n",
                 "8) Papaya Salad\n",
                 "9) Spanakopita\n",
                 "10) Tuscan Ragu\n"
               ]
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :view_recipe, when passed valid input 'Q', returns nil" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert nil == updated_context
    end

    test "in view :view_recipe, when passed invalid input '1', updates error but not view" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               error:
                 "I didn't understand that and I don't know what to do. Please enter a valid command.\n"
             } = updated_context

      assert %{view: :view_recipe} = updated_context
    end

    test "in view :grocery_list, when passed valid input 'I', updates content and view" do
      initial_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :grocery_list,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Bun Thit Nuong\n",
                 "2) Chicken Enmoladas\n",
                 "3) Classic Pasta\n",
                 "4) Cookies\n",
                 "5) Gua Bao\n",
                 "6) Ice Cubes\n",
                 "7) Lu Ro Fan\n",
                 "8) Papaya Salad\n",
                 "9) Spanakopita\n",
                 "10) Tuscan Ragu\n"
               ]
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :grocery_list, when passed valid input 'Q', returns nil" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :grocery_list,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert nil == updated_context
    end

    test "in view :grocery_list, when passed valid input '1', updates content but not view" do
      initial_context = %{
        input: "3",
        content: [
          "- 2 cups water (approximately)\n",
          "- 2 tablespoons water (additional if needed)\n"
        ],
        header: nil,
        view: :grocery_list,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "- 6 cups water (approximately)\n",
                 "- 6 tablespoons water (additional if needed)\n"
               ]
             } = updated_context

      assert %{view: :grocery_list} = updated_context
    end
  end

  describe "fetch_recipe/1" do
    test "takes a context and returns a context with view updated to :view_recipe, content, and last_input" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :grocery_list,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_recipe(initial_context)

      assert %{
               content:
                 "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"
             } = updated_context

      assert %{view: :view_recipe} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end

  describe "fetch_grocery_list/1" do
    test "takes a context and returns a context with view updated to :grocery_list, content, and last_input" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_grocery_list(initial_context)

      assert %{
               content: [
                 "- 2 cups water (approximately)\n",
                 "- 2 tablespoons water (additional if needed)\n"
               ]
             } = updated_context

      assert %{view: :grocery_list} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end
end
