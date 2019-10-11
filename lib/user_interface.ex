defmodule UserInterface do
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

  def display(message) do
    message
    |> IO.puts()
  end

  def display(%{io: io} = context, message) do
    message
    |> io.puts()

    context
  end

  def line_break() do
    display("\n")
  end

  def clear_screen(context) do
    IO.write(IO.ANSI.home())
    IO.write(IO.ANSI.clear())
    context
  end
end
