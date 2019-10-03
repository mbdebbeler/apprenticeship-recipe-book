defmodule UserInterface do
  def get_input(message, io \\ IO) do
    message
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> get_input(message, io)
  end

  def get_input(nil, _, io) do
    get_input(
      "I didn't understand that and I don't know what to do. Please enter a valid command.",
      io
    )
  end

  def get_input(message, _, _io) do
    String.capitalize(message)
  end

  def display(message) do
    message
    |> IO.puts()
  end

  def line_break(_args) do
    display("\n")
  end
end
