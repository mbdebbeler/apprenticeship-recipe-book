defmodule CommandLineFormatterTest do
  use ExUnit.Case
  import CommandLineFormatter

  describe "format_recipe/1" do
    test "takes a %Recipe{} struct and returns a string with formatted title, servings, ingredients and directions" do
      example_struct = %Recipe{
        directions: [
          %{
            direction:
              "Do not substitute smaller French lentils for the green or brown lentils. When preparing the Crispy Onions (see related content), be sure to reserve 3 tablespoons of the onion cooking oil for cooking the rice and lentils.",
            display_index: "Before you start"
          },
          %{
            direction:
              "FOR THE YOGURT SAUCE: Whisk all ingredients together in bowl. Refrigerate while preparing rice and lentils.",
            display_index: 1
          },
          %{
            direction:
              "FOR THE RICE AND LENTILS: Bring lentils, 4 cups water, and 1 teaspoon salt to boil in medium saucepan over high heat. Reduce heat to low and cook until lentils are tender, 15 to 17 minutes. Drain and set aside. While lentils cook, place rice in medium bowl and cover by 2 inches with hot tap water; let stand for 15 minutes.",
            display_index: 2
          },
          %{
            direction:
              "Using your hands, gently swish rice grains to release excess starch. Carefully pour off water, leaving rice in bowl. Add cold tap water to rice and pour off water. Repeat adding and pouring off cold tap water 4 to 5 times, until water runs almost clear. Drain rice in fine-mesh strainer.",
            display_index: 3
          },
          %{
            direction:
              "Heat reserved onion oil, garlic, coriander, cumin, cinnamon, allspice, 1/4 teaspoon pepper, and cayenne in Dutch oven over medium heat until fragrant, about 2 minutes. Add rice and cook, stirring occasionally, until edges of rice begin to turn translucent, about 3 minutes. Add 2 1/4 cups water, sugar, and 1 teaspoon salt and bring to boil. Stir in lentils, reduce heat to low, cover, and cook until all liquid is absorbed, about 12 minutes.",
            display_index: 4
          },
          %{
            direction:
              "Off heat, remove lid, fold dish towel in half, and place over pot; replace lid. Let stand for 10 minutes. Fluff rice and lentils with fork and stir in cilantro and half of crispy onions. Transfer to serving platter, top with remaining crispy onions, and serve, passing yogurt sauce separately.",
            display_index: 5
          }
        ],
        ingredients: [
          %Recipe{
            directions: nil,
            ingredients: [
              %Ingredient{
                details: nil,
                name: "plain whole-milk yogurt",
                quantity: "1",
                unit: 'cup'
              },
              %Ingredient{
                details: nil,
                name: "lemon juice",
                quantity: "2",
                unit: 'tablespoons'
              },
              %Ingredient{
                details: nil,
                name: "minced garlic",
                quantity: "1/2",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "salt",
                quantity: "1/2",
                unit: 'teaspoon'
              }
            ],
            servings: nil,
            title: "YOGURT SAUCE"
          },
          %Recipe{
            directions: nil,
            ingredients: [
              %Ingredient{
                details: "(1 1/4 cups) green or brown lentils, picked over and rinsed",
                name: "green or brown lentils",
                quantity: "8 1/2",
                unit: 'ounces'
              },
              %Ingredient{
                details: nil,
                name: "Salt and pepper",
                quantity: nil,
                unit: nil
              },
              %Ingredient{
                details: nil,
                name: "basmati rice",
                quantity: "1 1/4",
                unit: 'cups'
              },
              %Ingredient{
                details: nil,
                name: "Crispy Onions",
                quantity: "2",
                unit: 'cups'
              },
              %Ingredient{
                details: "minced",
                name: "garlic cloves",
                quantity: "3",
                unit: nil
              },
              %Ingredient{
                details: nil,
                name: "ground coriander",
                quantity: "1",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "ground cumin",
                quantity: "1",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "ground cinnamon",
                quantity: "1/2",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "ground allspice",
                quantity: "1/2",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "cayenne pepper",
                quantity: "1/8",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "sugar",
                quantity: "1",
                unit: 'teaspoon'
              },
              %Ingredient{
                details: nil,
                name: "minced fresh cilantro",
                quantity: "3",
                unit: 'tablespoons'
              }
            ],
            servings: nil,
            title: "RICE AND LENTILS"
          }
        ],
        servings: %{max: 6, min: 4},
        title: "Rice and Lentils with Crispy Onions (Mujaddara)"
      }

      expected_output =
        "Serves: 4 to 6\n\nIngredients:\nYOGURT SAUCE\n1 cup plain whole-milk yogurt"

      output = format_recipe(example_struct)

      assert String.contains?(output, expected_output)
    end
  end

  describe "format_ingredients/1" do
    test "takes a list of %Ingredient{} structs and returns a formatted string" do
      ingredients = [
        %Ingredient{details: nil, name: "table salt", quantity: "1/2", unit: 'teaspoon'},
        %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'tablespoon'},
        %Ingredient{
          details: "cut into 2 pieces",
          name: "chilled solid vegetable shortening",
          quantity: "1/4",
          unit: 'cup'
        }
      ]

      output = format_ingredients(ingredients)

      expected_output =
        "1/2 teaspoon table salt\n1 tablespoon sugar\n1/4 cup chilled solid vegetable shortening"

      assert output == expected_output
    end
  end
end
