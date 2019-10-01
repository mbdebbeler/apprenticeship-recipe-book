defmodule Controller do
  def main(_args) do
    run(:welcome_screen)
  end

  def run(prompt) when prompt != "Q" do
    Messages.get_prompt(prompt)
    |> UserInterface.get_input()
    |> run()
  end

  def run("Q") do
    :quit
    |> Messages.get_prompt()
    |> UserInterface.display()
  end

end
