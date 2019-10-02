defmodule Messages do
  def get_prompt(prompt) do
    messages = %{
      :R => "You typed R",
      :K => "You typed K",
      :D => "You typed D",
      :V => "View recipes",
      :welcome_screen => "Welcome to Recipe Book!\n\n\n",
      :menu => "What would you like to do?\n\n\nV = View a Recipe\nG = Generate a Grocery List\nQ = Quit\n",
      :grocery_list_header => "Groceries for this recipe:",
      :quit => "Goodbye!"
    }

    messages[prompt]
  end

  def get_recipe(name) do
    recipes = %{
      :ice_cubes => './recipes/ice_cubes.txt'
    }

    recipes[name]
  end
end
