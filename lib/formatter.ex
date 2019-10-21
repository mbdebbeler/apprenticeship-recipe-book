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

  def print_screen(%{error: error, menu: menu, header: header, content: content} = context) do
    screen = [header, content, menu, error]
    |> Enum.reject(fn x -> x == nil end)
    |> Enum.join("\n")
    
    CommandLineUI.display(screen, context)
  end

end
