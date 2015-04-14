defmodule Cedar.Vars do
  alias Cedar.Variable

  def resolve_var("@" <> key) do
    variable = Repo.get(Variable, key)
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