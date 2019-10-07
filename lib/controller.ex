defmodule Controller do
  def main(_args) do
    run(:welcome_screen)
  end

  def run("Q") do
    UserInterface.clear_screen()
    UserInterface.line_break()
    execute_command("Q")
  end

  def run(prompt) do
    UserInterface.clear_screen()
    execute_command(prompt)
    UserInterface.line_break()

    Messages.get_prompt(:menu)
    |> UserInterface.get_input()
    |> run()
  end

  def execute_command(input) do
    Messages.get_prompt(input)
    |> UserInterface.display()

    case input do
      :welcome_screen ->
        nil

      _ ->
        case Integer.parse(input) do
          :error ->
            case input do
              "G" ->
                Messages.get_recipe(:ice_cubes)
                |> RecipeParser.parse_grocery_list()
                |> Formatter.bulleted_list()
                |> UserInterface.display()

              "V" ->
                Messages.get_recipe(:all)
                |> Formatter.numbered_list()
                |> UserInterface.display()

              "Q" ->
                UserInterface.line_break()

              _ ->
                UserInterface.line_break()
                Messages.get_prompt(:unknown)
                |> UserInterface.display()
                UserInterface.line_break()
            end

          _ ->
            Messages.get_recipe(input)
            |> RecipeParser.read_file()
            |> UserInterface.display()
        end
    end
  end
end
