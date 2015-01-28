  use Amnesia

  defdatabase Db do

    #deftable Variable

    deftable Variable, [{ :id, autoincrement }, :key, :value, :owner], type: :ordered_set, index: [:key, :owner] do

      def add_variable(key, value, owner) do
        %Variable{key: key, value: value, owner: owner} |> Variable.write
      end

    end

  end
