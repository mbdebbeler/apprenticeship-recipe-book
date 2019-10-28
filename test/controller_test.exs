defmodule ControllerTest do
  use ExUnit.Case
  import Controller

  describe "run/1" do
    test "when passed 'Q', prints the quit message and leaves the context map unchanged." do
      initial_context = %{
        input: "Q",
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        io: FakeIO,
        prompt: "What would you like to do?",
        menu: :welcome,
        error: nil
      }

      updated_context = run(initial_context)

      assert %{view: :exit} = updated_context
    end
  end

  describe "run/2" do
    test "can be passed a dummy UI and with the same API and not blow up" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        io: FakeIO,
        prompt: "What would you like to do?",
        menu: :welcome,
        error: nil
      }

      updated_context = run(initial_context, FakeUI)

      assert %{view: :exit} = updated_context
    end
  end

  describe "update_context/1" do
    test "when view is :index, updates prompt, header, content and menu" do
      initial_context = %{
        input: "I",
        content: nil,
        header: nil,
        view: :index,
        io: FakeIO,
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
                 "1) Best Chicken Stew\n",
                 "2) Black Bean Soup\n",
                 "3) Cauliflower Soup\n",
                 "4) Chicken Caesar Salad\n",
                 "5) Esquites\n",
                 "6) Foolproof Pie Crust\n",
                 "7) Mujaddara\n",
                 "8) Radicchio And Grapefruit Salad\n",
                 "9) Skillet Charred Green Beans\n",
                 "10) Tagliatelle With Artichokes\n"
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
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Best Chicken Stew\n",
                 "2) Black Bean Soup\n",
                 "3) Cauliflower Soup\n",
                 "4) Chicken Caesar Salad\n",
                 "5) Esquites\n",
                 "6) Foolproof Pie Crust\n",
                 "7) Mujaddara\n",
                 "8) Radicchio And Grapefruit Salad\n",
                 "9) Skillet Charred Green Beans\n",
                 "10) Tagliatelle With Artichokes\n"
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
        io: FakeIO,
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
        io: FakeIO,
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
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content:
                 "Foolproof Pie Dough for a Single-Crust Pie\nSERVESServes one nine-inch Single-Crust Pie\n\nWHY THIS RECIPE WORKS\nWe wanted to make pie dough that was tender, flavorful, and consistent. Since water bonds with flour to form gluten, too much of it makes a crust tough. But rolling out dry dough is difficult. For a pie dough recipe that rolled out easily, we use a unique mixing method that \"waterproofs\" much of the flour so that it can't be hydrated and form gluten. We also use some vodka, which is just 60 percent water, and therefore produces less gluten. It contributes no alcohol flavor, since the alcohol vaporizes in the oven.\n\nINGREDIENTS\n1 1/4 cups unbleached all-purpose flour (6 1/4 ounces)\n1/2 teaspoon table salt\n1 tablespoon sugar\n6 tablespoons cold unsalted butter (3/4 stick), cut into 1/4-inch slices\n1/4 cup chilled solid vegetable shortening, cut into 2 pieces\n2 tablespoons vodka, cold\n2 tablespoons cold water\n*BEFORE YOU BEGIN\nVodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).\n\n1\nINSTRUCTIONS\nProcess 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.\n\n2\nSprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.\n\n3\nAdjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.\n\n4\nTrim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.\n\n5\nRemove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.\n"
             } = updated_context

      assert %{view: :view_recipe} = updated_context
    end

    test "in view :index, when passed valid input 'Q', returns context with view :exit" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :index,
        io: FakeIO,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :exit} = updated_context
    end

    test "in view :index, when passed invalid input '9', updates error message but not view" do
      initial_context = %{
        input: "46",
        content: nil,
        header: nil,
        view: :index,
        io: FakeIO,
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
        io: FakeIO,
        prompt: nil,
        menu: "Bar",
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "- 1 1/4 cups unbleached all-purpose flour (6 1/4 ounces)\n",
                 "- 1/2 teaspoon table salt\n",
                 "- 1 tablespoon sugar\n",
                 "- 6 tablespoons cold unsalted butter (3/4 stick), cut into 1/4-inch slices\n",
                 "- 1/4 cup chilled solid vegetable shortening, cut into 2 pieces\n",
                 "- 2 tablespoons vodka, cold\n",
                 "- 2 tablespoons cold water\n",
                 "- *BEFORE YOU BEGIN\n",
                 "- Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).\n"
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
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Best Chicken Stew\n",
                 "2) Black Bean Soup\n",
                 "3) Cauliflower Soup\n",
                 "4) Chicken Caesar Salad\n",
                 "5) Esquites\n",
                 "6) Foolproof Pie Crust\n",
                 "7) Mujaddara\n",
                 "8) Radicchio And Grapefruit Salad\n",
                 "9) Skillet Charred Green Beans\n",
                 "10) Tagliatelle With Artichokes\n"
               ]
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :view_recipe, when passed valid input 'Q', returns context with view :exit" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :exit} = updated_context
    end

    test "in view :view_recipe, when passed invalid input '1', updates error but not view" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :view_recipe,
        io: FakeIO,
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
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: [
                 "1) Best Chicken Stew\n",
                 "2) Black Bean Soup\n",
                 "3) Cauliflower Soup\n",
                 "4) Chicken Caesar Salad\n",
                 "5) Esquites\n",
                 "6) Foolproof Pie Crust\n",
                 "7) Mujaddara\n",
                 "8) Radicchio And Grapefruit Salad\n",
                 "9) Skillet Charred Green Beans\n",
                 "10) Tagliatelle With Artichokes\n"
               ]
             } = updated_context

      assert %{view: :index} = updated_context
    end

    test "in view :grocery_list, when passed valid input 'Q', returns context with view :exit" do
      initial_context = %{
        input: "Q",
        content: nil,
        header: nil,
        view: :grocery_list,
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :exit} = updated_context
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
        io: FakeIO,
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
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_recipe(initial_context)

      assert %{
               content:
                 "Foolproof Pie Dough for a Single-Crust Pie\nSERVESServes one nine-inch Single-Crust Pie\n\nWHY THIS RECIPE WORKS\nWe wanted to make pie dough that was tender, flavorful, and consistent. Since water bonds with flour to form gluten, too much of it makes a crust tough. But rolling out dry dough is difficult. For a pie dough recipe that rolled out easily, we use a unique mixing method that \"waterproofs\" much of the flour so that it can't be hydrated and form gluten. We also use some vodka, which is just 60 percent water, and therefore produces less gluten. It contributes no alcohol flavor, since the alcohol vaporizes in the oven.\n\nINGREDIENTS\n1 1/4 cups unbleached all-purpose flour (6 1/4 ounces)\n1/2 teaspoon table salt\n1 tablespoon sugar\n6 tablespoons cold unsalted butter (3/4 stick), cut into 1/4-inch slices\n1/4 cup chilled solid vegetable shortening, cut into 2 pieces\n2 tablespoons vodka, cold\n2 tablespoons cold water\n*BEFORE YOU BEGIN\nVodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).\n\n1\nINSTRUCTIONS\nProcess 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.\n\n2\nSprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.\n\n3\nAdjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.\n\n4\nTrim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.\n\n5\nRemove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.\n"
             } = updated_context

      assert %{view: :view_recipe} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end

  describe "fetch_grocery_list/1" do
    test "takes a context and returns a context with view updated to :grocery_list, content, and last_input" do
      initial_context = %{
        input: "G",
        content: nil,
        header: nil,
        view: :index,
        io: FakeIO,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_grocery_list(initial_context)

      assert %{
               content: [
                 "- 1 1/4 cups unbleached all-purpose flour (6 1/4 ounces)\n",
                 "- 1/2 teaspoon table salt\n",
                 "- 1 tablespoon sugar\n",
                 "- 6 tablespoons cold unsalted butter (3/4 stick), cut into 1/4-inch slices\n",
                 "- 1/4 cup chilled solid vegetable shortening, cut into 2 pieces\n",
                 "- 2 tablespoons vodka, cold\n",
                 "- 2 tablespoons cold water\n",
                 "- *BEFORE YOU BEGIN\n",
                 "- Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).\n"
               ]
             } = updated_context

      assert %{view: :grocery_list} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end
end
