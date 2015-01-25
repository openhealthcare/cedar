defmodule Cedar.Macros  do

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :rules, accumulate: true, persist: true
    end
  end

  defmacro defrule(signature, body) do
    f = elem(signature, 0)
    vl = elem(signature, 2)

    m = Enum.map hd(tl(vl)), fn (x) ->
      case x do
        {_, _, _} -> ""
        _ -> x
      end
    end

    quote do
      @rules [unquote(f)|unquote(m)]
      def unquote(signature) do
        unquote(body[:do])
      end
    end
  end

end