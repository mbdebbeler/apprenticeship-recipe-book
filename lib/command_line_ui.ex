defmodule CommandLineUI do
  def get_input(%{prompt: prompt} = context, io \\ IO) do
    prompt
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> sanitize_input(io)
    |> (fn input -> Map.put(context, :input, input) end).()
  end

  def refresh_display(context, io \\ IO) do
    context
    |> clear_display(io)
    |> CommandLineFormatter.prepare_next_screen()
    |> io.puts()

    context
  end

  def sanitize_input(nil, _io) do
    :invalid_input
  end

  def sanitize_input(message, _io) do
    if is_input_a_recipe?(message) do

    end

    recipes =
      Parser.prepare_recipe_index_map()
      |> Map.keys()
      |> Enum.with_index(1)
      |> Enum.into(%{})


# needs to handle Q, quit, I, Grocery list, G
  end

  defp fetch_recipe(message) do
    if Enum.member?(Map.values(recipes), message) do
      message
    else
      if Map.has_key?(recipes, message) do
        Map.fetch!(recipes, message)
      else
        :invalid_input
      end
    end
  end

  defp is_input_a_recipe?(message) do
    recipes =
      Parser.prepare_recipe_index_map()
      |> Map.keys()
      |> Enum.with_index(1)
      |> Enum.into(%{})
    Enum.member?(Map.values(recipes), message) || Map.has_key?(recipes, message)
  end

  defp clear_display(context, io) do
    io.write(IO.ANSI.home())
    io.write(IO.ANSI.clear())
    context
  end
end
