defmodule CommandLineUI do
  def get_input(%{prompt: prompt} = context, io \\ IO) do
    prompt
    |> io.gets()
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

  def sanitize_input(input, _io) do
    recipes =
      Parser.prepare_recipe_index_map()
      |> Map.keys()
      |> Enum.with_index(1)
      |> Enum.into(%{}, fn {k, v} -> {downcase_and_trim(k), "#{v}"} end)

    commands = %{
      "q" => :quit,
      "quit" => :quit,
      "exit" => :quit,
      "i" => :index,
      "index" => :index,
      "g" => :grocery_list,
      "grocery list" => :grocery_list,
      "grocery" => :grocery_list
    }

    message = downcase_and_trim(input)

    cond do
      is_input_a_command?(message, commands) ->
        fetch_command(message, commands)

      is_input_a_recipe?(message, recipes) ->
        fetch_recipe(message, recipes)

      true ->
        :invalid_input
    end
  end

  def downcase_and_trim(input) do
    input
    |> String.trim()
    |> String.downcase()
  end

  def is_input_a_command?(message, commands) do
    Map.has_key?(commands, message)
  end

  def fetch_command(message, commands) do
    Map.fetch!(commands, message)
  end

  defp fetch_recipe(message, recipes) do
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

  def is_input_a_recipe?(message, recipes) do
    Enum.member?(Map.values(recipes), message) || Map.has_key?(recipes, message)
  end

  defp clear_display(context, io) do
    io.write(IO.ANSI.home())
    io.write(IO.ANSI.clear())
    context
  end
end
