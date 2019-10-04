defmodule Formatter do
  def bulleted_list(ingredients) do
    ingredients
    |> Enum.map(fn x -> "- " <> x <> "\n" end)
  end
end
