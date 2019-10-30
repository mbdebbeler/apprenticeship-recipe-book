defmodule Messages do
  def get_header(view) do
    messages = %{
      :welcome => "Welcome to Recipe Book!\n",
      :index => "Recipe Index:",
      :view_recipe => "Your Recipe:",
      :grocery_list => "Groceries for this recipe:",
      :exit => "Goodbye!"
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
        "We either don't have that recipe or I can't find it. \n:(. Please choose another recipe.\n",
      :exit => nil
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
        "Menu Options:\n# = Change # of servings for this grocery list\nI = Return to Recipe Index\nQ = Quit\n\n",
      :exit => nil
    }

    messages[view]
  end

  def get_recipe(number) when number != :all do
    Parser.generate_recipe_map()
    |> Map.values()
    |> Enum.fetch!(String.to_integer(number) - 1)
  end

  def get_recipe(:all) do
    Parser.generate_recipe_map()
    |> Map.keys()
    |> generate_numbered_list
  end

  defp generate_numbered_list(items) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn {k, v} -> "#{v}) #{k}\n" end)
  end
end
