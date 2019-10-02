defmodule Controller do
  def main(_args) do
    run(:welcome_screen)
  end

  def run(prompt) when prompt != "Q" do
    Messages.get_prompt(prompt)
    |> UserInterface.display()

    Messages.get_prompt(:menu)
    |> UserInterface.get_input()
    |> run()
  end

  def run("Q") do
    :quit
    |> Messages.get_prompt()
    |> UserInterface.display()
  end

  def execute_command(input) do
    case input do
      :V ->
        Messages.get_prompt(input)
        |> UserInterface.display()

      _ ->
        false
    end

  end

end
