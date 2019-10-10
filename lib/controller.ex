defmodule Controller do
  def main(_args) do
    welcome_user()

    UserInterface.get_input(%{input: nil, view: :welcome, io: IO}, Messages.get_prompt(:welcome))
    |> run()
  end

  def run(%{input: "Q"} = context) do
    context
    |> UserInterface.clear_screen()
    |> execute_command()
  end

  def run(%{view: view} = context) do
    context
    |> UserInterface.clear_screen()
    |> execute_command()
    |> UserInterface.display(Messages.get_menu(view))
    |> UserInterface.get_input(Messages.get_prompt(view))
    |> run()
  end

  def execute_command(%{input: input} = context) do
    Messages.get_prompt(input)
    |> UserInterface.display()

    case Integer.parse(input) do
      :error ->
        parse_input(input)

      _ ->
        fetch_content(input)
    end

    context
  end

  def parse_input(input) do
    case input do
      "G" ->
        generate_grocery_list()

      "I" ->
        generate_index()

      "Q" ->
        nil

      _ ->
        unknown_error()
    end
  end

  def welcome_user() do
    Messages.get_prompt(:welcome)
    |> UserInterface.display()
  end

  def generate_grocery_list() do
    Messages.get_recipe(:ice_cubes)
    |> RecipeParser.parse_grocery_list()
    |> Formatter.bulleted_list()
    |> UserInterface.display()
  end

  def generate_index() do
    Messages.get_recipe(:all)
    |> Formatter.numbered_list()
    |> UserInterface.display()
  end

  def unknown_error() do
    Messages.get_prompt(:unknown)
    |> UserInterface.display()
  end

  def fetch_content(input) do
    Messages.get_recipe(input)
    |> RecipeParser.read_file()
    |> UserInterface.display()
  end
end
