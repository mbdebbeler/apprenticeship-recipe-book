defmodule ControllerTest do
  use ExUnit.Case
  import Controller

  describe "run/1" do
    test "when passed :quit, prints the quit message and leaves the context map unchanged." do
      initial_context = %{
        input: :quit,
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
        prompt: "What would you like to do?",
        menu: :welcome,
        error: nil
      }

      updated_context = run(initial_context, FakeUI)

      assert %{view: :exit} = updated_context
    end
  end

  describe "run/2" do
    test "can be passed a dummy UI and with the same API and not blow up" do
      initial_context = %{
        input: :quit,
        content: nil,
        header: "Welcome to Recipe Book!",
        view: :welcome,
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
        input: :index,
        content: nil,
        header: nil,
        view: :index,
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
    test "in view :welcome, when passed valid input :index, changes view to :index and updates content" do
      initial_context = %{
        input: :index,
        content: nil,
        header: nil,
        view: :welcome,
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
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: %Recipe{
                 directions: [
                   %{
                     direction:
                       "Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).",
                     display_index: "Before you start"
                   },
                   %{
                     direction:
                       "Process 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.",
                     display_index: 1
                   },
                   %{
                     direction:
                       "Sprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.",
                     display_index: 2
                   },
                   %{
                     direction:
                       "Adjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.",
                     display_index: 3
                   },
                   %{
                     direction:
                       "Trim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.",
                     display_index: 4
                   },
                   %{
                     direction:
                       "Remove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.",
                     display_index: 5
                   }
                 ],
                 ingredients: [
                   %Ingredient{
                     details: "(6 1/4 ounces)",
                     name: "unbleached all-purpose flour (6 1/4 )",
                     quantity: "1 1/4",
                     unit: 'cups'
                   },
                   %Ingredient{
                     details: nil,
                     name: "table salt",
                     quantity: "1/2",
                     unit: 'teaspoon'
                   },
                   %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'tablespoon'},
                   %Ingredient{
                     details: "(3/4 stick), cut into 1/4-inch slices",
                     name: "cold unsalted butter (3/4 stick)",
                     quantity: "6",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: "cut into 2 pieces",
                     name: "chilled solid vegetable shortening",
                     quantity: "1/4",
                     unit: 'cup'
                   },
                   %Ingredient{
                     details: "cold",
                     name: "vodka",
                     quantity: "2",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: nil,
                     name: "cold water",
                     quantity: "2",
                     unit: 'tablespoons'
                   }
                 ],
                 servings: [],
                 title: "Foolproof Pie Dough for a Single-Crust Pie"
               }
             } = updated_context

      assert %{view: :view_recipe} = updated_context
    end

    test "in view :index, when passed valid input 'Q', returns context with view :exit" do
      initial_context = %{
        input: :quit,
        content: nil,
        header: nil,
        view: :index,
        prompt: "Foo",
        menu: "Bar",
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :exit} = updated_context
    end

    test "in view :index, when passed :invalid_input, updates error message but not view" do
      initial_context = %{
        input: :invalid_input,
        content: nil,
        header: nil,
        view: :index,
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

      assert %{view: :index} = updated_context
    end

    test "in view :view_recipe, when passed valid input :grocery_list, updates content and view" do
      initial_context = %{
        input: :grocery_list,
        content: nil,
        header: nil,
        view: :view_recipe,
        prompt: nil,
        menu: "Bar",
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_content(initial_context)

      assert %{
               content: %Recipe{
                 directions: [
                   %{
                     direction:
                       "Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).",
                     display_index: "Before you start"
                   },
                   %{
                     direction:
                       "Process 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.",
                     display_index: 1
                   },
                   %{
                     direction:
                       "Sprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.",
                     display_index: 2
                   },
                   %{
                     direction:
                       "Adjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.",
                     display_index: 3
                   },
                   %{
                     direction:
                       "Trim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.",
                     display_index: 4
                   },
                   %{
                     direction:
                       "Remove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.",
                     display_index: 5
                   }
                 ],
                 ingredients: [
                   %Ingredient{
                     details: "(6 1/4 ounces)",
                     name: "unbleached all-purpose flour (6 1/4 )",
                     quantity: "1 1/4",
                     unit: 'cups'
                   },
                   %Ingredient{
                     details: nil,
                     name: "table salt",
                     quantity: "1/2",
                     unit: 'teaspoon'
                   },
                   %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'tablespoon'},
                   %Ingredient{
                     details: "(3/4 stick), cut into 1/4-inch slices",
                     name: "cold unsalted butter (3/4 stick)",
                     quantity: "6",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: "cut into 2 pieces",
                     name: "chilled solid vegetable shortening",
                     quantity: "1/4",
                     unit: 'cup'
                   },
                   %Ingredient{
                     details: "cold",
                     name: "vodka",
                     quantity: "2",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: nil,
                     name: "cold water",
                     quantity: "2",
                     unit: 'tablespoons'
                   }
                 ],
                 servings: [],
                 title: "Foolproof Pie Dough for a Single-Crust Pie"
               }
             } = updated_context

      assert %{view: :grocery_list} = updated_context
    end

    test "in view :view_recipe, when passed valid input :index, updates content and view" do
      initial_context = %{
        input: :index,
        content: nil,
        header: nil,
        view: :view_recipe,
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
        input: :quit,
        content: nil,
        header: nil,
        view: :view_recipe,
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

    test "in view :grocery_list, when passed valid input :index, updates content and view" do
      initial_context = %{
        input: :index,
        content: nil,
        header: nil,
        view: :grocery_list,
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
        input: :quit,
        content: nil,
        header: nil,
        view: :grocery_list,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_content(initial_context)

      assert %{view: :exit} = updated_context
    end
  end

  describe "fetch_recipe/1" do
    test "takes a context and returns a context with view updated to :view_recipe, content, and last_input" do
      initial_context = %{
        input: "6",
        content: nil,
        header: nil,
        view: :grocery_list,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: nil
      }

      updated_context = fetch_recipe(initial_context)

      assert %{
               content: %Recipe{
                 directions: [
                   %{
                     direction:
                       "Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).",
                     display_index: "Before you start"
                   },
                   %{
                     direction:
                       "Process 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.",
                     display_index: 1
                   },
                   %{
                     direction:
                       "Sprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.",
                     display_index: 2
                   },
                   %{
                     direction:
                       "Adjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.",
                     display_index: 3
                   },
                   %{
                     direction:
                       "Trim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.",
                     display_index: 4
                   },
                   %{
                     direction:
                       "Remove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.",
                     display_index: 5
                   }
                 ],
                 ingredients: [
                   %Ingredient{
                     details: "(6 1/4 ounces)",
                     name: "unbleached all-purpose flour (6 1/4 )",
                     quantity: "1 1/4",
                     unit: 'cups'
                   },
                   %Ingredient{
                     details: nil,
                     name: "table salt",
                     quantity: "1/2",
                     unit: 'teaspoon'
                   },
                   %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'tablespoon'},
                   %Ingredient{
                     details: "(3/4 stick), cut into 1/4-inch slices",
                     name: "cold unsalted butter (3/4 stick)",
                     quantity: "6",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: "cut into 2 pieces",
                     name: "chilled solid vegetable shortening",
                     quantity: "1/4",
                     unit: 'cup'
                   },
                   %Ingredient{
                     details: "cold",
                     name: "vodka",
                     quantity: "2",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: nil,
                     name: "cold water",
                     quantity: "2",
                     unit: 'tablespoons'
                   }
                 ],
                 servings: [],
                 title: "Foolproof Pie Dough for a Single-Crust Pie"
               }
             } = updated_context

      assert %{view: :view_recipe} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end

  describe "fetch_grocery_list/1" do
    test "takes a context and returns a context with view updated to :grocery_list, content, and last_input" do
      initial_context = %{
        input: :grocery_list,
        content: nil,
        header: nil,
        view: :index,
        prompt: nil,
        menu: nil,
        error: nil,
        last_input: "6"
      }

      updated_context = fetch_grocery_list(initial_context)

      assert %{
               content: %Recipe{
                 directions: [
                   %{
                     direction:
                       "Vodka is essential to the texture of the crust and imparts no flavor-do not substitute extra water. The alcohol is key to our recipe; if you don't have vodka on hand, you can use another 80 proof liquor. This dough will be moister and more supple than most standard pie doughs and will require more flour to roll out (up to 1/4 cup).",
                     display_index: "Before you start"
                   },
                   %{
                     direction:
                       "Process 3/4 cups flour, salt, and sugar together in food processor until combined, about 2 one-second pulses. Add butter and shortening and process until homogenous dough just starts to collect in uneven clumps, about 10 seconds (dough will resemble cottage cheese curds with some very small pieces of butter remaining, but there should be no uncoated flour). Scrape down sides and bottom of bowl with rubber spatula and redistribute dough evenly around processor blade. Add remaining 1/2 cup flour and pulse until mixture is evenly distributed around bowl and mass of dough has been broken up, 4 to 6 quick pulses. Empty mixture into medium bowl.",
                     display_index: 1
                   },
                   %{
                     direction:
                       "Sprinkle vodka and water over mixture. With rubber spatula, use folding motion to mix, pressing down on dough until dough is slightly tacky and sticks together. Flatten dough into 4-inch disk. Wrap in plastic wrap and refrigerate at least 45 minutes or up to 2 days.",
                     display_index: 2
                   },
                   %{
                     direction:
                       "Adjust oven rack to lowest position, place rimmed baking sheet on oven rack, and heat oven to 425 degrees. Remove dough from refrigerator and roll out on generously floured (up to 1/4 cup) work surface to 12-inch circle about 1/8 inch thick. Roll dough loosely around rolling pin and unroll into pie plate, leaving at least 1-inch overhang on each side. Working around circumference, ease dough into plate by gently lifting edge of dough with one hand while pressing into plate bottom with other hand. Leave overhanging dough in place; refrigerate until dough is firm, about 30 minutes.",
                     display_index: 3
                   },
                   %{
                     direction:
                       "Trim overhang to 1/2 inch beyond lip of pie plate. Fold overhang under itself; folded edge should be flush with edge of pie plate. Flute dough or press the tines of a fork against dough to flatten it against rim of pie plate. Refrigerate dough-lined plate until firm, about 15 minutes.",
                     display_index: 4
                   },
                   %{
                     direction:
                       "Remove pie pan from refrigerator, line crust with foil, and fill with pie weights or pennies. Bake for 15 minutes. Remove foil and weights, rotate plate, and bake for 5 to 10 minutes additional minutes until crust is golden brown and crisp.",
                     display_index: 5
                   }
                 ],
                 ingredients: [
                   %Ingredient{
                     details: "(6 1/4 ounces)",
                     name: "unbleached all-purpose flour (6 1/4 )",
                     quantity: "1 1/4",
                     unit: 'cups'
                   },
                   %Ingredient{
                     details: nil,
                     name: "table salt",
                     quantity: "1/2",
                     unit: 'teaspoon'
                   },
                   %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'tablespoon'},
                   %Ingredient{
                     details: "(3/4 stick), cut into 1/4-inch slices",
                     name: "cold unsalted butter (3/4 stick)",
                     quantity: "6",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: "cut into 2 pieces",
                     name: "chilled solid vegetable shortening",
                     quantity: "1/4",
                     unit: 'cup'
                   },
                   %Ingredient{
                     details: "cold",
                     name: "vodka",
                     quantity: "2",
                     unit: 'tablespoons'
                   },
                   %Ingredient{
                     details: nil,
                     name: "cold water",
                     quantity: "2",
                     unit: 'tablespoons'
                   }
                 ],
                 servings: [],
                 title: "Foolproof Pie Dough for a Single-Crust Pie"
               }
             } = updated_context

      assert %{view: :grocery_list} = updated_context
      assert %{last_input: "6"} = updated_context
    end
  end
end
