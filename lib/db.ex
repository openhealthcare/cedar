use Amnesia

defdatabase Db do

  #deftable Variable

  deftable Variable, [{ :id, autoincrement }, :key, :value, :owner], type: :ordered_set, index: [:key, :owner] do

    def add_variable(key, value, owner) do
      %Variable{key: key, value: value, owner: owner} |> Variable.write
    end

  end

end


defmodule Cedar.DbUtil do
  require Db.Variable
  require Exquisite


  def resolve_var("@" <> v) do
    val = Amnesia.transaction! do
      selection = Db.Variable.where key == v,
        select: value
      selection |> Amnesia.Selection.values
    end

    case val do
      [] -> v
      x -> hd(x)
    end
  end

  def resolve_var(v) do
    v
  end

end