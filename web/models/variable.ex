defmodule Cedar.Variable do
  use Cedar.Web, :model

  schema "variables" do
    field :key, :string
    field :value, :string
    field :owner, :string

    timestamps
  end

  @required_fields ~w(key value owner)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
