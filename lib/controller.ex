defmodule Controller do
  def main(_args) do
    welcome_user()
      %{
        input: :welcome,
        content: nil,
        view: :welcome,
        io: IO,
        prompt: Messages.get_prompt(:view),
        menu: Messages.get_menu(:view)
      }
      |> run()
  end

  def run(%{input: "Q"} = context) do
    context
    |> UserInterface.clear_screen()
    |> execute_command()
  end

  def run(context) do
    context
    # |> update_context()
    |> UserInterface.clear_screen()
    |> Formatter.print_content()
    |> Formatter.print_menu()
    |> UserInterface.get_input()
    |> execute_command()
    |> run()
  end

  # def update_context(context) do
  #   context
  #   %{context | prompt: Messages.get_prompt(:input)}
  #   %{context | menu: Messages.get_menu(:view)}
  #   context
  # end

  def execute_command(%{input: input} = context) do
    Messages.get_prompt(input)
    |> UserInterface.display()

    case Integer.parse(input) do
      :error ->
        parse_input(context)

      _ ->
        fetch_content(context)
    end
  end

  def parse_input(context) do
    case context.input do
      "G" ->
        generate_grocery_list(context)

      "I" ->
        generate_index(context)

      "Q" ->
        context

      _ ->
        unknown_error(context)
    end
  end

  def welcome_user() do
    Messages.get_prompt(:welcome)
    |> UserInterface.display()
  end

  def generate_grocery_list(%{content: content} = context) do
    Messages.get_recipe(content)
    |> RecipeParser.parse_grocery_list()
    |> Formatter.bulleted_list()
    |> UserInterface.display()

    %{context | view: :grocery_list}
    |> Formatter.print_menu()
  end

  def generate_index(context) do
    %{context | view: :index}
    |> Formatter.print_content()
    |> Formatter.print_menu()

    Messages.get_recipe(:all)
    |> Formatter.numbered_list()
    |> UserInterface.display()

    %{context | view: :index}
  end

  def unknown_error(context) do
    Messages.get_prompt(:unknown)
    |> UserInterface.display()

    context
  end

  def fetch_content(%{input: input} = context) do
    if content = Messages.get_recipe(input) do
      content
      |> RecipeParser.read_file()
      |> UserInterface.display()

      %{context | content: input, view: :recipe}
    else
      UserInterface.display(Messages.get_prompt(:not_found))
      context
    end
  end
end
