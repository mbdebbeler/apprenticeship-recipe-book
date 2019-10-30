defmodule CommandLineFormatterTest do
  use ExUnit.Case
  import CommandLineFormatter

  describe "format_recipe/1" do
    test "takes a %Recipe{} struct and returns a string with formatted title, servings, ingredients and directions" do
      example_struct = %Recipe{
        directions: [
          %{
            direction:
              "Do not substitute smaller French lentils for the green or brown lentils. When preparing the Crispy Onions (see related content), be sure to reserve  tablespoons of the onion cooking oil for cooking the rice and lentils.",
            display_index: "Before you start: "
          },
          %{
            direction:
              "FOR THE YOGURT SAUCE: Whisk all ingredients together in bowl. Refrigerate while preparing rice and lentils.",
            display_index: 1
          },
          %{
            direction:
              "FOR THE RICE AND LENTILS: Bring lentils,  cups water, and  teaspoon salt to boil in medium saucepan over high heat. Reduce heat to low and cook until lentils are tender,  to  minutes. Drain and set aside. While lentils cook, place rice in medium bowl and cover by  inches with hot tap water; let stand for  minutes.",
            display_index: 2
          },
          %{
            direction:
              "Using your hands, gently swish rice grains to release excess starch. Carefully pour off water, leaving rice in bowl. Add cold tap water to rice and pour off water. Repeat adding and pouring off cold tap water  to  times, until water runs almost clear. Drain rice in fine-mesh strainer.",
            display_index: 3
          },
          %{
            direction:
              "Heat reserved onion oil, garlic, coriander, cumin, cinnamon, allspice, 1/4 teaspoon pepper, and cayenne in Dutch oven over medium heat until fragrant, about  minutes. Add rice and cook, stirring occasionally, until edges of rice begin to turn translucent, about  minutes. Add  1/4 cups water, sugar, and  teaspoon salt and bring to boil. Stir in lentils, reduce heat to low, cover, and cook until all liquid is absorbed, about  minutes.",
            display_index: 4
          },
          %{
            direction:
              "Off heat, remove lid, fold dish towel in half, and place over pot; replace lid. Let stand for  minutes. Fluff rice and lentils with fork and stir in cilantro and half of crispy onions. Transfer to serving platter, top with remaining crispy onions, and serve, passing yogurt sauce separately.",
            display_index: 5
          }
        ],
        ingredients: [
          "YOGURT SAUCE",
          "1 cup plain whole-milk yogurt",
          "2 tablespoons lemon juice",
          "1/2 teaspoon minced garlic",
          "1/2 teaspoon salt",
          "RICE AND LENTILS",
          "8 1/2 ounces (1 1/4 cups) green or brown lentils, picked over and rinsed",
          "Salt and pepper",
          "1 1/4 cups basmati rice",
          "2 cups Crispy Onions",
          "3 garlic cloves, minced",
          "1 teaspoon ground coriander",
          "1 teaspoon ground cumin",
          "1/2 teaspoon ground cinnamon",
          "1/2 teaspoon ground allspice",
          "1/8 teaspoon cayenne pepper",
          "1 teaspoon sugar",
          "3 tablespoons minced fresh cilantro"
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
end
