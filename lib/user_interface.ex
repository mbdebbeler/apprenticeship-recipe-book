defmodule UserInterface do
  def get_input(message, io \\ IO) do
    message
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> get_input(message, io)
  end

  def get_input(nil, _, io) do
    "!"
  end

  def get_input(message, _, _io) do
    String.capitalize(message)
  end

  def display(message) do
    message
    |> IO.puts()
  end

  def line_break() do
    display("\n")
  end

  def clear_screen() do
    IO.write(IO.ANSI.home())
    IO.write(IO.ANSI.clear())
  end
end
