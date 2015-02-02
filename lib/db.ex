use Amnesia

defdatabase Db do

  #deftable Variable

  deftable Variable, [{ :id, autoincrement }, :key, :value, :owner], type: :ordered_set, index: [:key, :owner] do
  end

end


defmodule Cedar.DbUtil do
  require Db.Variable
  require Exquisite

  def add_variable(key, value, owner) do
    Amnesia.transaction! do
      %Db.Variable{key: key, value: value, owner: owner} |> Db.Variable.write
    end
  end

  def delete_variable(id) do
    Amnesia.transaction! do
      Db.Variable.read!(id) |> Db.Variable.delete
    end
  end


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