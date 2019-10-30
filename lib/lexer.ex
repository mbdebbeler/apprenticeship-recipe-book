defmodule Lexer do
  def lex(s) when is_binary(s), do: s |> to_charlist |> lex

  def lex(s) do
    {:ok, tokens, _} = :recipe_lexer.string(s)
    tokens
  end
end
