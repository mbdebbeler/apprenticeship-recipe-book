defmodule Formatter do
  def bulleted_list(items) do
    items
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
  end

  def numbered_list(items) do
    items
    |> Enum.map(fn x -> "1) " <> x <> "\n" end)
  end
end
