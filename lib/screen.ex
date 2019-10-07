defmodule Screen do
  defstruct current_view: nil,
            prompt: nil,
            user_input: nil,
            menu: nil

  def build() do
    %Screen{
      current_view: :welcome,
      prompt: Messages.get_prompt(:welcome),
      user_input: nil,
      menu: nil
    }
  end

  def build(user_input, _screen) do
    %Screen{
      user_input: user_input,
      prompt: Messages.get_prompt(user_input)
    }
  end
end
