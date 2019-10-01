defmodule Controller do
  require Formatter

  @user_prompts %{
    :welcome_screen => "Welcome to Recipe Book!",
    :grocery_list => "Groceries for this recipe:"
  }

  @recipe_files %{
    :ice_cubes => './recipes/ice_cubes.txt'
  }

  def main do
    Formatter.print(@user_prompts[:welcome_screen])
  end

end
