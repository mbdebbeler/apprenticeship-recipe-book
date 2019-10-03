defmodule Controller do
  def main(_args) do
    run(:welcome_screen)
  end

  def run(prompt) when prompt != "Q" do
    parse_input(prompt)
    |> UserInterface.display()

    Messages.get_prompt(:menu)
    |> UserInterface.get_input()
    |> run()
  end

  def run("Q") do
    parse_input("Q")
    |> UserInterface.display()
  end

  def parse_input(input) do
    if Enum.member?(["G", "V", "I", "Q", :welcome_screen], input) do
      Messages.get_prompt(input)
      execute_command(input)
    else
      Messages.get_prompt(:unknown)
    end
  end

  def execute_command(input) do
    case input do
      "G" ->
        Messages.get_recipe(:ice_cubes)
        |> RecipeParser.parse_grocery_list()

      "V" ->
        Messages.get_recipe(:all)

      "I" ->
        Messages.get_recipe(:ice_cubes)
        |> RecipeParser.read_file()

      "Q" ->
        Messages.get_prompt(input)

      _ ->
        Messages.get_prompt(input)
    end
  end
end
