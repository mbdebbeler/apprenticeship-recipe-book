defmodule Messages do
  def get_prompt(prompt) do
    messages = %{
      "V" => "Which recipe would you like to view?",
      :welcome_screen => "Welcome to Recipe Book!\n\n\n",
      :menu => "Menu Options:\nV = View a Recipe\nG = Generate a Grocery List\nQ = Quit\n",
      "G" => "Groceries for this recipe:",
      "Q" => "Goodbye!",
      :unknown =>
        "I didn't understand that and I don't know what to do. Please enter a valid command."
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
      :ice_cubes => './recipes/ice_cubes.txt'
    }

    Map.values(recipes)
  end
end
