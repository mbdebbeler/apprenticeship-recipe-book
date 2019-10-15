defmodule Messages do
  def get_header(view) do
    messages = %{
      :welcome => "Welcome to Recipe Book!\n",
      :index => "Recipe Index:",
      :view_recipe => "Your Recipe:",
      :grocery_list => "Groceries for this recipe:",
      "Q" => "Goodbye!"
    }

    messages[view]
  end

  def get_prompt(prompt) do
    messages = %{
      "I" => "Which recipe would you like to view? Type the number and press enter.\n",
      :welcome => "What would you like to do?\n",
      :index => "Which recipe would you like to view? Type the number and press enter.\n",
      :unknown =>
        "I didn't understand that and I don't know what to do. Please enter a valid command.\n",
      :not_found =>
        "We either don't have that recipe or I can't find it. \n:(. Please choose another recipe.\n"
    }

    messages[prompt]
  end

  def get_menu(view) do
    messages = %{
      :welcome => "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
      :index => "Menu Options:\n# = View a Specific Recipe\nQ = Quit\n\n",
      :view_recipe =>
        "Menu Options:\nG = Generate a Grocery List for this Recipe\nI = Return to Recipe Index\nQ = Quit\n\n",
      :grocery_list =>
        "Menu Options:\n# = Change # of servings for this grocery list\nI = Return to Recipe Index\nQ = Quit\n\n"
    }

    messages[view]
  end

  def get_recipe(name) when name != :all do
    recipes = %{
      "1" => './recipes/ice_cubes.txt',
      :ice_cubes => './recipes/ice_cubes.txt',
      :not_found =>
        "We either don't have that recipe or I can't find it. \n:(. Please choose another recipe.\n"
    }

    recipes[name]
  end

  def get_recipe(:all) do
    recipes = %{
      "1" => "Ice Cubes"
    }

    Map.values(recipes)
  end
end
