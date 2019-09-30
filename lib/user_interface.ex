defmodule UserInterface do

  def get_input(message, io \\ IO) do
    message
    |> io.gets()
    |> String.trim()
    |> String.first()
    |> get_input(message, io)
  end

  def get_input(nil, _, io) do
    get_input("I am asking for your input, user.\n", io)
  end

  def get_input(message, _, _io) do
    String.capitalize(message)
  end

end
