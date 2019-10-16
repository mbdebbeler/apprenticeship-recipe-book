defmodule WordToNumber do

  def convert(number) do
    to_number(String.downcase(number))
  end

  defp to_number("one"), do: 1
  defp to_number("a"), do: 1
  defp to_number("an"), do: 1
  defp to_number("two" ),  do: 2
  defp to_number("three" ),  do: 3
  defp to_number("four" ),  do: 4
  defp to_number("five" ),  do: 5
  defp to_number("six" ),  do: 6
  defp to_number("seven" ),  do: 7
  defp to_number("eight" ),  do: 8
  defp to_number("nine" ),  do: 9
  defp to_number("ten" ), do: 10
  defp to_number("eleven" ), do: 11
  defp to_number("twelve" ), do: 12
  defp to_number("thirteen" ), do: 13
  defp to_number("fourteen" ), do: 14
  defp to_number("fifteen" ), do: 15
  defp to_number("sixteen" ), do: 16
  defp to_number("seventeen" ), do: 17
  defp to_number("eighteen" ), do: 18
  defp to_number("nineteen" ), do: 19
  defp to_number("twenty" ), do: 20
  defp to_number(_), do: nil

end
