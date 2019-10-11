defmodule Formatter do
  def bulleted_list(items) do
    items
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
  end

  def numbered_list(items) do
    items
    |> Enum.map(fn x -> "1) " <> x <> "\n" end)
  end

  def print_screen(context) do
    context
    |> print_header()
    |> print_content()
    |> print_menu()
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
