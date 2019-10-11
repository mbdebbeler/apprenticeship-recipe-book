defmodule Messages do
  def get_prompt(prompt) do
    messages = %{
      "I" => "Which recipe would you like to view?",
      :welcome => "Welcome to Recipe Book!",
      :menu => "Menu Options:\nV = View a Recipe\nQ = Quit\n\n",
      "G" => "Groceries for this recipe:",
      "Q" => "Goodbye!",
      :unknown =>
        "I didn't understand that and I don't know what to do. Please enter a valid command.",
      "L" => "*** Enter 'G' to generate a grocery list for this recipe! ***",
      :not_found =>
        "We either don't have that recipe or I can't find it. \n:(. \nPlease choose another recipe."
    }

    messages[prompt]
  end

  def get_menu(view) do
    messages = %{
      :welcome => "Menu Options:\nI = View Recipe Index\nQ = Quit\n\n",
      :index => "Menu Options:\n(1-9) = View a Specific Recipe\nQ = Quit\n\n",
      :view_recipe =>
        "Menu Options:\nG = Generate a Grocery List for this Recipt\nI = Return to Recipe Index\nQ = Quit\n\n",
      :grocery_list => "Menu Options:\nI = Return to Recipe Index\nQ = Quit\n\n"
    }

    messages[view]
  end

  def get_recipe(name) when name != :all do
    recipes = %{
      "1" => './recipes/ice_cubes.txt',
      :ice_cubes => './recipes/ice_cubes.txt'
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
