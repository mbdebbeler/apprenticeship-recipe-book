defmodule ParserTest do
  use ExUnit.Case
  import Parser

  describe "parse_tokens/1" do
    test "returns a %Recipe{} struct with title, servings, ingredients and directions" do
      filepath = './recipes/mujaddara.txt'
      output = parse_tokens(filepath)

      first_expected_direction = %{
        direction:
          "Do not substitute smaller French lentils for the green or brown lentils. When preparing the Crispy Onions (see related content), be sure to reserve 3 tablespoons of the onion cooking oil for cooking the rice and lentils.",
        display_index: "Before you start"
      }

      assert %{title: "Rice and Lentils with Crispy Onions (Mujaddara)"} = output
      assert %{servings: %{min: 4, max: 6}} = output
      assert Enum.member?(output.directions, first_expected_direction)
    end
  end

  describe "parse_ingredients/1" do
    test "when there are sublists, returns a List of ingredients with subrecipe titles included in list" do
      filepath = './recipes/mujaddara.txt'
      tokens = Lexer.lex(read_file(filepath))

      output = parse_ingredients(tokens)
      first_expected_ingredient = "YOGURT SAUCE"

      assert Enum.member?(output, first_expected_ingredient)
    end

    test "when there are no sublists, returns a List of ingredients" do
      filepath = './recipes/esquites.txt'
      tokens = Lexer.lex(read_file(filepath))

      output = parse_ingredients(tokens)
      first_expected_ingredient = "3 tablespoons lime juice, plus extra for seasoning (2 limes)"

      assert Enum.member?(output, first_expected_ingredient)
    end
  end

  describe "new_parse_ingredients/1" do
    test "when there are sublists, returns a %Recipe{} with :title, a string and :ingredients, a list of %Ingredient{} structs, with fields :quantity, :unit, :name, :details" do
      filepath = './recipes/mujaddara.txt'
      tokens = Lexer.lex(read_file(filepath))

      output = new_parse_ingredients(tokens)

      expected_output = [
        %Recipe{
          directions: nil,
          ingredients: [
            %Ingredient{
              details: nil,
              name: "plain whole-milk yogurt",
              quantity: "1",
              unit: 'cup'
            },
            %Ingredient{details: nil, name: "lemon juice", quantity: "2", unit: 'tablespoons'},
            %Ingredient{details: nil, name: "minced garlic", quantity: "1/2", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "salt", quantity: "1/2", unit: 'teaspoon'}
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
            %Ingredient{details: nil, name: "Salt and pepper", quantity: nil, unit: nil},
            %Ingredient{details: nil, name: "basmati rice", quantity: "1 1/4", unit: 'cups'},
            %Ingredient{details: nil, name: "Crispy Onions", quantity: "2", unit: 'cups'},
            %Ingredient{details: "minced", name: "garlic cloves", quantity: "3", unit: nil},
            %Ingredient{details: nil, name: "ground coriander", quantity: "1", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "ground cumin", quantity: "1", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "ground cinnamon", quantity: "1/2", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "ground allspice", quantity: "1/2", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "cayenne pepper", quantity: "1/8", unit: 'teaspoon'},
            %Ingredient{details: nil, name: "sugar", quantity: "1", unit: 'teaspoon'},
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
      ]

      assert output == expected_output
    end

    test "when there are no sublists, returns a List of %Ingredient{} structs, each with fields :quantity, :unit, :name, :details" do
      filepath = './recipes/esquites.txt'
      tokens = Lexer.lex(read_file(filepath))
      output = new_parse_ingredients(tokens)

      ingredient_with_all_parts = %Ingredient{
        details: "plus extra for seasoning (2 limes)",
        name: "lime juice",
        quantity: "3",
        unit: 'tablespoons'
      }

      ingredient_missing_a_field = %Ingredient{
        details: "stemmed and cut into 1/8-inch-thick rings",
        name: "serrano chiles",
        quantity: "1-2",
        unit: nil
      }

      assert Enum.member?(output, ingredient_with_all_parts)
      assert Enum.member?(output, ingredient_missing_a_field)
    end

    test "when there are no sublists and only one ingredient, returns an %Ingredient{} struct, with fields :quantity, :unit, :name, :details" do
      tokens = [
        {:int, 8, 3},
        {:whitespace, 8, ' '},
        {:word, 8, 'tablespoons'},
        {:whitespace, 8, ' '},
        {:word, 8, 'lime'},
        {:whitespace, 8, ' '},
        {:word, 8, 'juice'},
        {:char, 8, ','},
        {:whitespace, 8, ' '},
        {:word, 8, 'plus'},
        {:whitespace, 8, ' '},
        {:word, 8, 'extra'},
        {:whitespace, 8, ' '},
        {:word, 8, 'for'},
        {:whitespace, 8, ' '},
        {:word, 8, 'seasoning'},
        {:whitespace, 8, ' '},
        {:char, 8, '('},
        {:int, 8, 2},
        {:whitespace, 8, ' '},
        {:word, 8, 'limes'},
        {:char, 8, ')'},
        {:new_line, 8, '\n'}
      ]

      output = handle_sub_recipes(tokens)

      expected_output = [
        %Ingredient{
          quantity: "3",
          unit: 'tablespoons',
          name: "lime juice",
          details: "plus extra for seasoning (2 limes)"
        }
      ]

      assert expected_output == output
    end

    test "when there are no sublists and only one ingredient with fields missing, returns an %Ingredient{} struct, with nil for those fields" do
      tokens = [
        {:whitespace, 8, ' '},
        {:new_line, 8, '\n'}
      ]

      output = handle_sub_recipes(tokens)
      expected_output = [%Ingredient{quantity: nil, unit: nil, name: nil, details: nil}]

      assert expected_output == output
    end
  end

  describe "chunk_by_upcased_lines" do
    test "groups lines by whether they have an upcased word as the first word" do
      lines = [
        [
          {:upcase_word, 8, 'YOGURT'},
          {:whitespace, 8, ' '},
          {:upcase_word, 8, 'SAUCE'},
          {:new_line, 8, '\n'}
        ],
        [
          {:int, 10, 2},
          {:whitespace, 10, ' '},
          {:word, 10, 'tablespoons'},
          {:whitespace, 10, ' '},
          {:word, 10, 'lemon'},
          {:whitespace, 10, ' '},
          {:word, 10, 'juice'},
          {:new_line, 10, '\n'}
        ],
        [
          {:upcase_word, 13, 'RICE'},
          {:whitespace, 13, ' '},
          {:upcase_word, 13, 'AND'},
          {:whitespace, 13, ' '},
          {:upcase_word, 13, 'LENTILS'},
          {:new_line, 13, '\n'}
        ],
        [
          {:word, 15, 'Salt'},
          {:whitespace, 15, ' '},
          {:word, 15, 'and'},
          {:whitespace, 15, ' '},
          {:word, 15, 'pepper'},
          {:new_line, 15, '\n'}
        ],
        [
          {:int, 17, 2},
          {:whitespace, 17, ' '},
          {:word, 17, 'cups'},
          {:whitespace, 17, ' '},
          {:word, 17, 'Crispy'},
          {:whitespace, 17, ' '},
          {:word, 17, 'Onions'},
          {:new_line, 17, '\n'}
        ]
      ]

      output = chunk_by_upcased_lines(lines)

      expected_output = 2

      assert Enum.count(output) == expected_output
    end
  end

  describe "build_recipe_struct" do
    test "when passed a nested list of upcased lines and ingredients, returns a recipe struct" do
      tokens = [
        [
          [
            {:upcase_word, 8, 'YOGURT'},
            {:whitespace, 8, ' '},
            {:upcase_word, 8, 'SAUCE'},
            {:new_line, 8, '\n'}
          ]
        ],
        [
          [
            {:int, 10, 2},
            {:whitespace, 10, ' '},
            {:word, 10, 'tablespoons'},
            {:whitespace, 10, ' '},
            {:word, 10, 'lemon'},
            {:whitespace, 10, ' '},
            {:word, 10, 'juice'},
            {:new_line, 10, '\n'}
          ]
        ]
      ]

      output = build_recipe_struct(tokens)

      expected_output = %Recipe{
        directions: nil,
        servings: nil,
        ingredients: [%Ingredient{
          details: nil,
          name: "lemon juice",
          quantity: "2",
          unit: 'tablespoons'
        }],
        title: "YOGURT SAUCE"
      }

      assert output == expected_output
    end
  end

  describe "parse_details/2" do
    test "when passed a list of tokens, returns the joined, unwrapped values of all the tokens after ',' or '('" do
      tokens = [
        {:int, 8, 3},
        {:whitespace, 8, ' '},
        {:word, 8, 'tablespoons'},
        {:whitespace, 8, ' '},
        {:word, 8, 'lime'},
        {:whitespace, 8, ' '},
        {:word, 8, 'juice'},
        {:char, 8, ','},
        {:whitespace, 8, ' '},
        {:word, 8, 'plus'},
        {:whitespace, 8, ' '},
        {:word, 8, 'extra'},
        {:whitespace, 8, ' '},
        {:word, 8, 'for'},
        {:whitespace, 8, ' '},
        {:word, 8, 'seasoning'},
        {:whitespace, 8, ' '},
        {:char, 8, '('},
        {:int, 8, 2},
        {:whitespace, 8, ' '},
        {:word, 8, 'limes'},
        {:char, 8, ')'},
        {:new_line, 8, '\n'}
      ]

      output = parse_details(tokens)
      expected_output = "plus extra for seasoning (2 limes)"

      assert expected_output == output
    end

    test "when passed a list of tokens, returns nil if there is no ',' or '('" do
      tokens = [
        {:int, 8, 3},
        {:whitespace, 8, ' '},
        {:word, 8, 'tablespoons'},
        {:whitespace, 8, ' '},
        {:word, 8, 'lime'},
        {:whitespace, 8, ' '},
        {:word, 8, 'juice'},
        {:whitespace, 8, ' '},
        {:word, 8, 'plus'},
        {:whitespace, 8, ' '},
        {:word, 8, 'extra'},
        {:whitespace, 8, ' '},
        {:word, 8, 'for'},
        {:whitespace, 8, ' '},
        {:word, 8, 'seasoning'},
        {:whitespace, 8, ' '},
        {:int, 8, 2},
        {:whitespace, 8, ' '},
        {:word, 8, 'limes'},
        {:char, 8, ')'},
        {:new_line, 8, '\n'}
      ]

      output = parse_details(tokens)
      expected_output = nil

      assert expected_output == output
    end
  end

  describe "parse_unit/1" do
    test "when passed a list of tokens, returns the value of the first :word token if it is present in the array of units" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_unit(tokens)
      expected_output = 'cup'

      assert output == expected_output
    end

    test "when passed a list of tokens, returns nil if not word tokens are present in the array of units" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_unit(tokens)
      expected_output = nil

      assert output == expected_output
    end
  end

  describe "parse_quantity/1" do
    test "when passed a list of tokens, returns the first integer or fraction" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_quantity(tokens)
      expected_output = "1"

      assert output == expected_output
    end

    test "when passed a list of tokens, returns the unwrapped, joined value of everything up to the first word token" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:fraction, 9, '1/2'},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_quantity(tokens)
      expected_output = "1 1/2"

      assert output == expected_output
    end

    test "when passed a list of tokens that has no integers or fractions, returns nil" do
      tokens = [
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_quantity(tokens)
      expected_output = nil

      assert output == expected_output
    end
  end

  describe "parse_name/1" do
    test "when passed a list of tokens, returns the unwrapped, joined values of everything that isn't details, unit or quantity" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = parse_name(tokens)
      expected_output = "plain whole-milk"

      assert output == expected_output
    end
  end

  describe "has_sub_recipe?/1" do
    test "returns a boolean, false if list of ingredients tokens does not contain an :upcased_word token" do
      tokens = [
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = has_sub_recipe?(tokens)
      expected_output = false

      assert output == expected_output
    end

    test "returns a boolean, true if list of ingredients tokens contains an :upcased_word token" do
      tokens = [
        {:upcase_word, 8, 'YOGURT'},
        {:whitespace, 8, ' '},
        {:upcase_word, 8, 'SAUCE'},
        {:new_line, 8, '\n'},
        {:int, 9, 1},
        {:whitespace, 9, ' '},
        {:word, 9, 'cup'},
        {:whitespace, 9, ' '},
        {:word, 9, 'plain'},
        {:whitespace, 9, ' '},
        {:word, 9, 'whole'},
        {:char, 9, '-'},
        {:word, 9, 'milk'}
      ]

      output = has_sub_recipe?(tokens)
      expected_output = true

      assert output == expected_output
    end
  end

  describe "parse_directions/1" do
    test "returns a List of directions, each stored in a map that contains :display_index and :direction" do
      filepath = './recipes/mujaddara.txt'
      tokens = Lexer.lex(read_file(filepath))

      output = parse_directions(tokens)

      first_expected_direction = %{
        direction:
          "Do not substitute smaller French lentils for the green or brown lentils. When preparing the Crispy Onions (see related content), be sure to reserve 3 tablespoons of the onion cooking oil for cooking the rice and lentils.",
        display_index: "Before you start"
      }

      second_expected_direction = %{
        direction:
          "FOR THE YOGURT SAUCE: Whisk all ingredients together in bowl. Refrigerate while preparing rice and lentils.",
        display_index: 1
      }

      assert Enum.member?(output, first_expected_direction)
      assert Enum.member?(output, second_expected_direction)
    end
  end

  describe "parse_servings/2" do
    test "returns a Map of servings for each recipe with :min and :max fields" do
      tokens = [
        {:word, 1, 'Rice'},
        {:whitespace, 1, ' '},
        {:word, 1, 'and'},
        {:whitespace, 1, ' '},
        {:word, 1, 'Lentils'},
        {:whitespace, 1, ' '},
        {:word, 1, 'with'},
        {:whitespace, 1, ' '},
        {:word, 1, 'Crispy'},
        {:whitespace, 1, ' '},
        {:word, 1, 'Onions'},
        {:whitespace, 1, ' '},
        {:char, 1, '('},
        {:word, 1, 'Mujaddara'},
        {:char, 1, ')'},
        {:new_line, 1, '\n'},
        {:section_start, 2, 'SERVESServes'},
        {:whitespace, 2, ' '},
        {:int, 2, 4},
        {:whitespace, 2, ' '},
        {:word, 2, 'to'},
        {:whitespace, 2, ' '},
        {:int, 2, 6},
        {:section_end, 2, '\n\n'}
      ]

      output = parse_servings(tokens)
      expected_output = %{min: 4, max: 6}

      assert expected_output == output
    end
  end

  describe "parse_title/1" do
    test "filters tokens, joins them into a string, updates the recipe struct" do
      tokens = [
        {:int, 1, 2},
        {:whitespace, 1, ' '},
        {:word, 1, 'cups'},
        {:whitespace, 1, ' '},
        {:word, 1, 'water'},
        {:whitespace, 1, ' '},
        {:char, 1, '('},
        {:word, 1, 'approximately'},
        {:char, 1, ')'},
        {:new_line, 1, '\n'},
        {:int, 2, 2},
        {:whitespace, 2, ' '},
        {:word, 2, 'tablespoons'},
        {:whitespace, 2, ' '},
        {:word, 2, 'water'},
        {:whitespace, 2, ' '},
        {:char, 2, '('},
        {:word, 2, 'additional'},
        {:whitespace, 2, ' '},
        {:word, 2, 'if'},
        {:whitespace, 2, ' '},
        {:word, 2, 'needed'},
        {:char, 2, ')'},
        {:section_end, 2, '\n\n'}
      ]

      output = parse_title(tokens)
      expected_output = "2 cups water (approximately)"
      assert output == expected_output
    end
  end

  describe "prepare_recipe_index_map/0" do
    output = prepare_recipe_index_map()

    expected_output = %{
      "Best Chicken Stew" => "recipes/best_chicken_stew.txt",
      "Black Bean Soup" => "recipes/black_bean_soup.txt",
      "Cauliflower Soup" => "recipes/cauliflower_soup.txt",
      "Chicken Caesar Salad" => "recipes/chicken_caesar_salad.txt",
      "Esquites" => "recipes/esquites.txt",
      "Foolproof Pie Crust" => "recipes/foolproof_pie_crust.txt",
      "Mujaddara" => "recipes/mujaddara.txt",
      "Radicchio And Grapefruit Salad" => "recipes/radicchio_and_grapefruit_salad.txt",
      "Skillet Charred Green Beans" => "recipes/skillet_charred_green_beans.txt",
      "Tagliatelle With Artichokes" => "recipes/tagliatelle_with_artichokes.txt"
    }

    assert output == expected_output
  end

  describe "fetch_list_of_recipe_files/1" do
    test "returns a List of of all the recipes in the recipes file" do
      filepath = "./recipes/*.txt"
      output = fetch_list_of_recipe_files(filepath)

      expected_output = [
        "recipes/best_chicken_stew.txt",
        "recipes/black_bean_soup.txt",
        "recipes/cauliflower_soup.txt",
        "recipes/chicken_caesar_salad.txt",
        "recipes/esquites.txt",
        "recipes/foolproof_pie_crust.txt",
        "recipes/mujaddara.txt",
        "recipes/radicchio_and_grapefruit_salad.txt",
        "recipes/skillet_charred_green_beans.txt",
        "recipes/tagliatelle_with_artichokes.txt"
      ]

      assert output == expected_output
    end
  end

  describe "parse_list_of_recipe_names/1" do
    test "returns a list of file names formatted as capitalized English titles" do
      filepath = "./recipes/*.txt"
      output = parse_list_of_recipe_names(filepath)

      expected_output = [
        "Best Chicken Stew",
        "Black Bean Soup",
        "Cauliflower Soup",
        "Chicken Caesar Salad",
        "Esquites",
        "Foolproof Pie Crust",
        "Mujaddara",
        "Radicchio And Grapefruit Salad",
        "Skillet Charred Green Beans",
        "Tagliatelle With Artichokes"
      ]

      assert output == expected_output
    end
  end

  describe "read_file/1" do
    test "accepts string filepath and returns string of file contents" do
      filepath = './recipes/mujaddara.txt'

      expected_output =
        "Rice and Lentils with Crispy Onions (Mujaddara)\nSERVESServes 4 to 6\n\nWHY THIS RECIPE WORKS\nMujaddara, the rice and beans of the Middle East, is a hearty one-dish vegetarian rice and lentil pilaf containing large brown or green lentils and crispy fried onion strings. For the pilaf, we found that precooking the lentils and soaking the rice in hot water before combining them ensured that both components cooked evenly. We pare down the typically fussy process of batch-frying onions in several cups of oil to a single batch of onions fried in just 1 1/2 cups of oil. The trick: removing a good bit of the onion water before frying by tossing them with salt, microwaving them for 5 minutes, and drying them thoroughly.\n\nINGREDIENTS\nYOGURT SAUCE\n1 cup plain whole-milk yogurt\n2 tablespoons lemon juice\n1/2 teaspoon minced garlic\n1/2 teaspoon salt\nRICE AND LENTILS\n8 1/2 ounces (1 1/4 cups) green or brown lentils, picked over and rinsed\nSalt and pepper\n1 1/4 cups basmati rice\n2 cups Crispy Onions\n3 garlic cloves, minced\n1 teaspoon ground coriander\n1 teaspoon ground cumin\n1/2 teaspoon ground cinnamon\n1/2 teaspoon ground allspice\n1/8 teaspoon cayenne pepper\n1 teaspoon sugar\n3 tablespoons minced fresh cilantro\n*BEFORE YOU BEGIN\nDo not substitute smaller French lentils for the green or brown lentils. When preparing the Crispy Onions (see related content), be sure to reserve 3 tablespoons of the onion cooking oil for cooking the rice and lentils.\n\n1\nINSTRUCTIONS\nFOR THE YOGURT SAUCE: Whisk all ingredients together in bowl. Refrigerate while preparing rice and lentils.\n\n2\nFOR THE RICE AND LENTILS: Bring lentils, 4 cups water, and 1 teaspoon salt to boil in medium saucepan over high heat. Reduce heat to low and cook until lentils are tender, 15 to 17 minutes. Drain and set aside. While lentils cook, place rice in medium bowl and cover by 2 inches with hot tap water; let stand for 15 minutes.\n\n3\nUsing your hands, gently swish rice grains to release excess starch. Carefully pour off water, leaving rice in bowl. Add cold tap water to rice and pour off water. Repeat adding and pouring off cold tap water 4 to 5 times, until water runs almost clear. Drain rice in fine-mesh strainer.\n\n4\nHeat reserved onion oil, garlic, coriander, cumin, cinnamon, allspice, 1/4 teaspoon pepper, and cayenne in Dutch oven over medium heat until fragrant, about 2 minutes. Add rice and cook, stirring occasionally, until edges of rice begin to turn translucent, about 3 minutes. Add 2 1/4 cups water, sugar, and 1 teaspoon salt and bring to boil. Stir in lentils, reduce heat to low, cover, and cook until all liquid is absorbed, about 12 minutes.\n\n5\nOff heat, remove lid, fold dish towel in half, and place over pot; replace lid. Let stand for 10 minutes. Fluff rice and lentils with fork and stir in cilantro and half of crispy onions. Transfer to serving platter, top with remaining crispy onions, and serve, passing yogurt sauce separately.\n"

      output = read_file(filepath)

      assert output == expected_output
    end
  end

  describe "generate_bulleted_list/1" do
    test "when passed a list, it will return a list formatted with dashes and newlines" do
      example_ingredients = [
        "2 cups water (approximately)",
        "2 tablespoons water (additional if needed)"
      ]

      expected_output = [
        "- 2 cups water (approximately)\n",
        "- 2 tablespoons water (additional if needed)\n"
      ]

      output = generate_bulleted_list(example_ingredients)

      assert output == expected_output
    end
  end
end
