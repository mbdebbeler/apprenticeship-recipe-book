ExUnit.start()

defmodule FakeIO do
  def gets("Fake Prompt Message"), do: "y"
  def gets(nil), do: nil

  def gets("I didn't understand that and I don't know what to do. Please enter a valid command."),
    do: "!"

end
