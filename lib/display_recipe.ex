defmodule DisplayRecipe.CLI do
  use Application
  require IEx

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @help_menu %{
    "test" => "test"
  }

  @outgoing_messages %{
    :welcome_screen => "Welcome to Recipe Book!"
  }

  def main do
    print(@outgoing_messages[:welcome_screen])
  end

  def print(text) do
    IO.puts(text)
  end

  def receive_command do
    user_input = IO.gets("") |> String.trim |> String.downcase
    valid?(user_input)
  end

  def valid?(user_input) do
    if @help_menu[user_input] do
        print(@help_menu[user_input])
    else
        print("Invalid command. I don't know what to do.")
    end
  end

end

DisplayRecipe.CLI.main
