defmodule Formatter do
  def bulleted_list(items) do
    items
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
  end

  def numbered_list(items) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn {k, v} -> "#{v}) #{k}\n" end)
  end

  def print_screen(context) do
    context
    |> print_header()
    |> print_content()
    |> print_menu()
    |> print_error()
  end

  def print_error(%{error: error} = context) do
    error
    |> UserInterface.display()

    %{context | error: nil}
  end

  def print_header(%{header: header} = context) do
    header
    |> UserInterface.display()

    context
  end

  def print_menu(%{menu: menu} = context) do
    menu
    |> UserInterface.display()

    context
  end

  def print_content(%{content: content} = context) do
    content
    |> UserInterface.display()

    context
  end
end
