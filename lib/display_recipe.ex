defmodule DisplayRecipe.CLI do
  use Application

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @outgoing_messages %{
    :welcome_screen => "Welcome to Recipe Book!"
  }

  def main do
    print(@outgoing_messages[:welcome_screen])
  end

  def print(text) do
    IO.puts(text)
  end 

end

DisplayRecipe.CLI.main
