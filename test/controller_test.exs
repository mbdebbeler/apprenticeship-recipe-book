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
        menu: "Bar",
        error: nil,
        last_input: nil
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{prompt: nil} != update_context(example_context)
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{content: ["1) Ice Cubes\n"]} = fetch_content(example_context)
      assert %{view: :index} = fetch_content(example_context)
    end

    test "in view :welcome, when passed invalid input 'V', updates error but not view." do
      example_context = %{
        input: "V",
        content: nil,
        header: nil,
        view: :welcome,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{view: :welcome} = fetch_content(example_context)
      assert %{error: nil} != fetch_content(example_context)
    end

    test "in view :welcome, when passed valid input :welcome, passes context through unchanged" do
      example_context = %{
        input: :welcome,
        content: nil,
        header: nil,
        view: :welcome,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{content: nil} != fetch_content(example_context)
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert nil == fetch_content(example_context)
    end

    test "in view :index, when passed invalid input '9', updates error message but not view" do
      example_context = %{
        input: "9",
        content: nil,
        header: nil,
        view: :index,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{error: nil} != fetch_content(example_context)
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
        menu: "Bar",
        error: nil,
        last_input: "1"
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
        menu: "Bar",
        error: nil,
        last_input: nil
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert nil == fetch_content(example_context)
    end

    test "in view :view_recipe, when passed invalid input '1', updates error but not view" do
      example_context = %{
        input: "1",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{error: nil} != fetch_content(example_context)
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
        menu: "Bar",
        error: nil,
        last_input: nil
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
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert nil == fetch_content(example_context)
    end

    test "in view :grocery_list, when passed invalid input '1', updates error but not view" do
      example_context = %{
        input: "1",
        content: nil,
        header: nil,
        view: :grocery_list,
        io: IO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      assert %{error: nil} != fetch_content(example_context)
      assert %{view: :grocery_list} = fetch_content(example_context)
    end
  end
end
