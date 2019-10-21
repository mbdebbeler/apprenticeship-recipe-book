defmodule CommandLineUI do
  def get_input(%{prompt: prompt, io: io} = context) do
    prompt
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> sanitize_input(io)
    |> (fn input -> Map.put(context, :input, input) end).()
  end

  def sanitize_input(nil, _io) do
    "!"
  end

  def sanitize_input(message, _io) do
    String.capitalize(message)
  end

  def display(message, %{io: io} = context) do
    message
    |> io.puts()

    context
  end

  def clear_screen(%{io: io} = context) do
    context
    |> io.write(IO.ANSI.home())
    |> io.write(IO.ANSI.clear())
  end

end
