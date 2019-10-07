defmodule UserInterface do
  def get_input(state, message, io \\ IO) do
    input = message
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> sanitize_input(message, io)
    %{state | input: input}
  end

  def sanitize_input(nil, _, _io) do
    "!"
  end

  def sanitize_input(message, _, _io) do
    String.capitalize(message)
  end

  def display(message) do
    message
    |> IO.puts()
  end

  def display(state, message) do
    message
    |> IO.puts()
    state
  end

  def line_break() do
    display("\n")
  end

  def clear_screen(state) do
    IO.write(IO.ANSI.home())
    IO.write(IO.ANSI.clear())
    state
  end
end
