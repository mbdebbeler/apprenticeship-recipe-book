defmodule Messages do
  def get_prompt(prompt) do
    messages = %{
      "V" => "Which recipe would you like to view?",
      :welcome_screen => "Welcome to Recipe Book!",
      :menu => "Menu Options:\nV = View a Recipe\nQ = Quit\n\n",
      "G" => "Groceries for this recipe:",
      "Q" => "Goodbye!",
      :unknown =>
        "I didn't understand that and I don't know what to do. Please enter a valid command.",
      "L" => "*** Enter 'G' to generate a grocery list for this recipe! ***"
    }

    messages[prompt]
  end

  def get_recipe(name) when name != :all do
    recipes = %{
      :ice_cubes => './recipes/ice_cubes.txt'
    }

    recipes[name]
  end

  def get_recipe(:all) do
    recipes = %{
      "Ice Cubes" => './recipes/ice_cubes.txt'
    }

    Map.keys(recipes)
  end
end
