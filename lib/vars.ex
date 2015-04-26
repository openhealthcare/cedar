defmodule Cedar.Vars do
  alias Cedar.Variable
  alias Cedar.VarServer

  def resolve_var("@" <> key) do
    variable = VarServer.lookup(key)
    IO.inspect variable
    resolve_result(variable.value, key)
  end

  def resolve_var(key) do
    key
  end

  defp resolve_result(_, deflt) do
    deflt
  end

  defp resolve_result(val, _deflt) do
    val
  end

end
