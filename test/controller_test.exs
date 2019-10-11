defmodule ControllerTest do
  use ExUnit.Case
  import Controller
  import ExUnit.CaptureIO

  describe "run/1" do
    test "when passed 'Q', prints the quit message and leaves the context map unchanged." do
      quit_prompt = "\e[H\e[2JGoodbye!\n\n"
      example_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: "Foo",
        menu: "Bar"
      }
      output = fn -> run(example_context) end
      assert capture_io(output) == quit_prompt
    end
  end

  describe "update_context/1" do
    test "when view is :index, updates prompt, header and menu" do
      example_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: "Foo",
        menu: "Bar"
      }

      assert %{prompt: "Which recipe would you like to view? Type the number and press enter."} = update_context(example_context)
    end
  end

  describe "fetch_content/1" do
      test "in view :welcome, when passed valid input 'I', changes view to :index and updates content" do
        example_context = %{
          input: "I",
          content: nil,
          header: nil,
          view: :welcome,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: ["1) Ice Cubes\n"]} = fetch_content(example_context)
        assert %{view: :index} = fetch_content(example_context)
      end

      test "in view :welcome, when passed invalid input 'V', changes content but not view." do
        example_context = %{
          input: "V",
          content: nil,
          header: nil,
          view: :welcome,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }
        assert %{view: :welcome} = fetch_content(example_context)
        assert %{content: "I didn't understand that and I don't know what to do. Please enter a valid command."} = fetch_content(example_context)
      end

      test "in view :welcome, when passed valid input :welcome, passes context through unchanged" do
        example_context = %{
          input: :welcome,
          content: nil,
          header: nil,
          view: :welcome,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert example_context == fetch_content(example_context)
      end

      test "in view :index, when passed valid input '1', updates content and view" do
        example_context = %{
          input: "1",
          content: nil,
          header: nil,
          view: :index,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"} = fetch_content(example_context)
        assert %{view: :view_recipe} = fetch_content(example_context)
      end

      test "in view :index, when passed valid input 'Q', returns nil" do
        example_context = %{
          input: "Q",
          content: nil,
          header: nil,
          view: :index,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert nil == fetch_content(example_context)
      end

      test "in view :index, when passed invalid input '9', updates content with error message but leaves view" do
        example_context = %{
          input: "9",
          content: nil,
          header: nil,
          view: :index,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: "We either don't have that recipe or I can't find it. \n:(. Please choose another recipe."} = fetch_content(example_context)
        assert %{view: :index} = fetch_content(example_context)
      end

      test "in view :view_recipe, when passed valid input 'G', updates content and view" do
        example_context = %{
          input: "G",
          content: nil,
          header: nil,
          view: :view_recipe,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: nil} != fetch_content(example_context)
        assert %{view: :grocery_list} = fetch_content(example_context)
      end

      test "in view :view_recipe, when passed valid input 'I', updates content and view" do
        example_context = %{
          input: "I",
          content: nil,
          header: nil,
          view: :view_recipe,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: nil} != fetch_content(example_context)
        assert %{view: :index} = fetch_content(example_context)
      end

      test "in view :view_recipe, when passed valid input 'Q', returns nil" do
        example_context = %{
          input: "Q",
          content: nil,
          header: nil,
          view: :view_recipe,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert nil == fetch_content(example_context)
      end

      test "in view :view_recipe, when passed invalid input '1', updates content but not view" do
        example_context = %{
          input: "1",
          content: nil,
          header: nil,
          view: :view_recipe,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: nil} != fetch_content(example_context)
        assert %{view: :view_recipe} = fetch_content(example_context)
      end

      test "in view :grocery_list, when passed valid input 'I', updates content and view" do
        example_context = %{
          input: "I",
          content: nil,
          header: nil,
          view: :grocery_list,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: nil} != fetch_content(example_context)
        assert %{view: :index} = fetch_content(example_context)
      end

      test "in view :grocery_list, when passed valid input 'Q', returns nil" do
        example_context = %{
          input: "Q",
          content: nil,
          header: nil,
          view: :grocery_list,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert nil == fetch_content(example_context)
      end

      test "in view :grocery_list, when passed invalid input '1', updates content but not view" do
        example_context = %{
          input: "1",
          content: nil,
          header: nil,
          view: :grocery_list,
          io: IO,
          prompt: "Foo",
          menu: "Bar"
        }

        assert %{content: nil} != fetch_content(example_context)
        assert %{view: :grocery_list} = fetch_content(example_context)
      end
  end
end
