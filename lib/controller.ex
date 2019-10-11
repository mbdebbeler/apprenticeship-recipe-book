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
      error: nil
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

  def fetch_content(%{input: input, view: view} = context) do
    case view do
      :welcome ->
        case input do
          "I" ->
            recipe_list = Messages.get_recipe(:all) |> Formatter.numbered_list()
            %{context | content: recipe_list, view: :index}

          "Q" ->
            nil

          :welcome ->
            context

          _ ->
            error = Messages.get_prompt(:unknown)
            %{context | error: error}
        end

      :index ->
        case input do
          "Q" ->
            nil

          _ ->
            if Messages.get_recipe(input) do
              recipe =
                Messages.get_recipe(input)
                |> RecipeParser.read_file()

              %{context | content: recipe, view: :view_recipe}
            else
              error = Messages.get_recipe(:not_found)
              %{context | error: error}
            end
        end

      :view_recipe ->
        case input do
          "G" ->
            if Messages.get_recipe("1") do
              grocery_list =
                Messages.get_recipe("1")
                |> RecipeParser.parse_grocery_list()
                |> Formatter.bulleted_list()

              %{context | content: grocery_list, view: :grocery_list}
            else
              error = Messages.get_recipe(:not_found)
              %{context | error: error}
            end

          "I" ->
            content = Messages.get_recipe(:all) |> Formatter.numbered_list()
            %{context | content: content, view: :index}

          "Q" ->
            nil

          _ ->
            error = Messages.get_prompt(:unknown)
            %{context | error: error}
        end

      :grocery_list ->
        case input do
          "I" ->
            content = Messages.get_recipe(:all) |> Formatter.numbered_list()
            %{context | content: content, view: :index}

          "Q" ->
            nil

          _ ->
            error = Messages.get_prompt(:unknown)
            %{context | error: error}
        end

      _ ->
        context
    end
  end
end
