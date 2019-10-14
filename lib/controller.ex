defmodule Controller do
  def main(_args) do
    %{
      input: :welcome,
      header: nil,
      content: nil,
      view: :welcome,
      io: IO,
      prompt: nil,
      menu: nil,
      error: nil,
      last_input: nil
    }
    |> run()
  end

  def run(%{input: "Q"} = context) do
    context
    |> UserInterface.clear_screen()

    UserInterface.display("Goodbye!\n")
  end

  def run(context) do
    context
    |> UserInterface.clear_screen()
    |> update_context()
    |> Formatter.print_screen()
    |> UserInterface.get_input()
    |> run()
  end

  def update_context(context) do
    context
    |> update_content()
    |> update_header()
    |> update_menu()
    |> update_prompt()
  end

  def update_prompt(%{view: view} = context) do
    %{context | prompt: Messages.get_prompt(view)}
  end

  def update_header(%{view: view} = context) do
    %{context | header: Messages.get_header(view)}
  end

  def update_menu(%{view: view} = context) do
    %{context | menu: Messages.get_menu(view)}
  end

  def update_content(context) do
    context
    |> fetch_content()
  end

  def fetch_content(%{input: "Q", view: _}) do
    nil
  end

  def fetch_content(%{input: "I", view: _} = context) do
    content = Messages.get_recipe(:all) |> Formatter.numbered_list()
    %{context | content: content, view: :index}
  end

  def fetch_content(%{input: _, view: :grocery_list} = context) do
    fetch_unknown_error(context)
  end

  def fetch_content(%{input: input, view: :welcome} = context) do
    case input do
      :welcome ->
        context

      _ ->
        fetch_unknown_error(context)
    end
  end

  def fetch_content(%{input: input, view: :index} = context) do
    if Messages.get_recipe(input) do
      recipe =
        Messages.get_recipe(input)
        |> RecipeParser.read_file()

      %{context | content: recipe, view: :view_recipe, last_input: input}
    else
      fetch_not_found_error(context)
    end
  end

  def fetch_content(%{input: input, view: :view_recipe, last_input: last_input} = context) do
    case input do
      "G" ->
        if Messages.get_recipe(last_input) do
          grocery_list =
            Messages.get_recipe(last_input)
            |> RecipeParser.parse_grocery_list()
            |> Formatter.bulleted_list()

          %{context | content: grocery_list, view: :grocery_list}
        else
          fetch_not_found_error(context)
        end

      _ ->
        fetch_unknown_error(context)
    end
  end

  def fetch_unknown_error(context) do
    error = Messages.get_prompt(:unknown)
    %{context | error: error}
  end

  def fetch_not_found_error(context) do
    error = Messages.get_prompt(:not_found)
    %{context | error: error}
  end
end
