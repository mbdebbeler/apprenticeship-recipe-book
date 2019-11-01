ExUnit.start()

defmodule FakeIO do
  def gets(nil), do: nil
  def gets("Welcome to Recipe Book!"), do: "I"

  def gets("I didn't understand that and I don't know what to do. Please enter a valid command."),
    do: "!"

  def puts(message), do: message

  def write(context, _function),
    do: context

  def write(io),
    do: io
end

defmodule FakeUI do
  def get_input(context, _io \\ FakeIO) do
    context
  end

  def refresh_display(context, _io \\ FakeIO) do
    context
  end
end
