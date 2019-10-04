defmodule Controller do
  def main(_args) do
    run(:welcome_screen)
  end

  def run(prompt) when prompt != "Q" do
    UserInterface.clear_screen()
    parse_input(prompt)
    UserInterface.line_break()

    Messages.get_prompt(:menu)
    |> UserInterface.get_input()
    |> run()
  end

  def run("Q") do
    execute_command("Q")
  end

  def parse_input(input) do
    if Enum.member?(["G", "V", "I", :welcome_screen], input) do
      Messages.get_prompt(input)
      |> UserInterface.display()

      execute_command(input)
    else
      Messages.get_prompt(:unknown)
      |> UserInterface.display()

      UserInterface.line_break()
    end
  end

  def execute_command(input) do
    case input do
      "G" ->
        Messages.get_recipe(:ice_cubes)
        |> RecipeParser.parse_grocery_list()
        |> Formatter.bulleted_list()
        |> UserInterface.display()

      "V" ->
        Messages.get_recipe(:all)
        |> Formatter.bulleted_list()
        |> UserInterface.display()

      "I" ->
        Messages.get_recipe(:ice_cubes)
        |> RecipeParser.read_file()
        |> UserInterface.display()

        Messages.get_prompt("L")
        |> UserInterface.display()

      "Q" ->
        UserInterface.clear_screen()
        UserInterface.line_break()

        Messages.get_prompt(input)
        |> UserInterface.display()

        UserInterface.line_break()

      :welcome_screen ->
        nil
    end
  end
end
