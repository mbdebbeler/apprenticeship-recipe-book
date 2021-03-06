defmodule Controller do
  def main(_args) do
    %{
      input: :welcome,
      header: nil,
      content: nil,
      view: :welcome,
      prompt: nil,
      menu: nil,
      error: nil,
      last_input: nil
    }
    |> run()
  end

  def run(context, ui \\ CommandLineUI)

  def run(%{input: :quit} = context, ui) do
    context
    |> update_context()
    |> ui.refresh_display()
  end

  def run(context, ui) do
    context
    |> update_context()
    |> ui.refresh_display()
    |> ui.get_input()
    |> run()
  end

  def update_context(context) do
    context
    |> update_content()
    |> update_header()
    |> update_menu()
    |> update_prompt()
  end

  defp update_prompt(%{view: view} = context) do
    %{context | prompt: Messages.get_prompt(view)}
  end

  defp update_header(%{view: view} = context) do
    %{context | header: Messages.get_header(view)}
  end

  defp update_menu(%{view: view} = context) do
    %{context | menu: Messages.get_menu(view)}
  end

  defp update_content(context) do
    %{context | error: nil}
    |> fetch_content()
  end

  def fetch_content(%{input: :quit, view: _} = context) do
    %{context | view: :exit, content: nil}
  end

  def fetch_content(%{input: :invalid_input, view: _} = context) do
    fetch_unknown_error(context)
  end

  def fetch_content(%{input: :index, view: _} = context) do
    content = Messages.get_recipe(:all)
    %{context | content: content, view: :index}
  end

  def fetch_content(%{input: input, view: :grocery_list} = context) do
    if Parser.is_valid_quantity(input) do
      context
    else
      fetch_unknown_error(context)
    end
  end

  def fetch_content(%{input: :welcome, view: :welcome} = context) do
    context
  end

  def fetch_content(%{input: input, view: :index} = context) do
    if fetch_recipe(context) do
      fetch_recipe(context)
    else
      fetch_not_found_error(context)
    end
  end

  def fetch_content(%{input: :grocery_list, view: :view_recipe, last_input: last_input} = context) do
    if Messages.get_recipe(last_input) do
      fetch_grocery_list(context)
    else
      fetch_not_found_error(context)
    end
  end

  def fetch_content(%{input: _} = context) do
    fetch_unknown_error(context)
  end

  def fetch_recipe(%{input: input} = context) do
    recipe =
      Messages.get_recipe(input)
      |> Parser.parse_tokens()

    %{context | content: recipe, view: :view_recipe, last_input: input}
  end

  def fetch_grocery_list(%{last_input: last_input} = context) do
    grocery_list =
      Messages.get_recipe(last_input)
      |> Parser.parse_tokens()

    %{context | content: grocery_list, view: :grocery_list}
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
