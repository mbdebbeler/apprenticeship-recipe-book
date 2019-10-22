defmodule Parser do
  @doc """
  Tokenizes an input string
  """
  def old_parse(input) do
    case :recipe_lexer.string(to_charlist(input)) do
      {:ok, tokens, _} ->
        tokens

      {:error, reason, _} ->
        reason
    end
  end

  # def parse0(str) do
  #   {:ok, tokens, _line} = :recipe_lexer.string(to_charlist(str))
  #   {:ok, result} = :recipe_parser.parse(str)
  #   result
  # end
  # def parse1(str) do
  #   with {:ok, tokens, _} <- :recipe_lexer.string(to_charlist(str)),
  #        {:ok, result} <- :recipe_parser.parse(tokens) do
  #     result
  #   else
  #     {:error, reason, _} ->
  #       reason
  #
  #     {:error, {_, :recipe_parser, reason}} ->
  #       to_string(reason)
  #   end
  # end
  #
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
  def complete_parse({:error, {line, _, message}}), do: {:error, ["Line: #{line} "] ++ message |> Enum.join}

end
