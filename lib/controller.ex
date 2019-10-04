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
    Messages.get_prompt(input)
    |> UserInterface.display()

    execute_command(input)
  end

  def execute_command(input) do
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
                UserInterface.clear_screen()
                UserInterface.line_break()

                Messages.get_prompt(input)
                |> UserInterface.display()

                UserInterface.line_break()

              _ ->
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
