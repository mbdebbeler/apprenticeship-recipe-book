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

  defp sanitize_input(nil, _io) do
    :invalid_input
  end

  defp sanitize_input(message, _io) do
    String.capitalize(message)
  end

  defp clear_display(context, io) do
    io.write(IO.ANSI.home())
    io.write(IO.ANSI.clear())
    context
  end
end
