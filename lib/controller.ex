defmodule Controller do
  def main(_args) do
    run(:welcome)
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

  def new_main(_args) do
    screen = Screen.build()
    new_run(screen)
  end

  def new_run(screen) do
    UserInterface.get_input(screen.prompt)
    |> update_screen(screen)
  end

  def update_screen(input, screen) do
    Screen.build(input, screen)
  end

  def execute_command(input) do
    Messages.get_prompt(input)
    |> UserInterface.display()

    case input do
      :welcome ->
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
