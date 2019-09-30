defmodule Formatter do

  def print(text) do
    IO.puts(text)
  end

  def pretty_print_list(message, ingredients) do
    print(message)
    ingredients |> Enum.each (fn ingredient -> print(ingredient) end)
  end

end
