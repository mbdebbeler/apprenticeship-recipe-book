defmodule CommandLineUI do

  defimpl UI, for: CommandLineUI do
    def get_input(%{prompt: prompt, io: io} = context) do
      prompt
      |> io.gets()
      |> String.trim()
      |> String.first()
      |> sanitize_input(io)
      |> (fn input -> Map.put(context, :input, input) end).()
    end

    def sanitize_input(nil, _io) do
      :invalid_input
    end

    def sanitize_input(message, _io) do
      String.capitalize(message)
    end

    def refresh_display(%{io: io} = context) do
      context
      |> clear_display(io)
      |> prepare_next_screen()
      |> io.puts()

      context
    end

    def prepare_next_screen(%{error: error, menu: menu, header: header, content: content}) do
      [header, content, menu, error]
      |> Enum.reject(fn x -> x == nil end)
      |> Enum.join("\n")
    end

    def clear_display(context, io) do
      io.write(IO.ANSI.home())
      io.write(IO.ANSI.clear())
      context
    end

  end



end
