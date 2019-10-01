defmodule Formatter do
  def bulleted_list(ingredients) do
    ingredients
    |> Enum.each(fn x -> "- " <> x end)
  end
end
