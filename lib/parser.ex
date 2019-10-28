defmodule Parser do
  def simple_lex(input) do
    case :recipe_lexer.string(to_charlist(input)) do
      {:ok, tokens, _} ->
        tokens

      {:error, reason, _} ->
        reason
    end
  end

  def lex(s) when is_binary(s), do: s |> to_charlist |> lex

  def lex(s) do
    {:ok, tokens, _} = :recipe_lexer.string(s)
    tokens
  end

  def parse(s) when is_binary(s), do: s |> to_charlist |> parse

  def parse(s) do
    {:ok, tokens, _} = :recipe_lexer.string(s)
    :recipe_parser.parse(tokens) |> complete_parse
  end

  def complete_parse({:ok, ast}), do: ast

  def complete_parse({:error, {line, _, message}}),
    do: {:error, (["Line: #{line} "] ++ message) |> Enum.join()}
end
