defmodule Cedar.Repo.Migrations.CreateVariable do
  use Ecto.Migration

  def change do
    create table(:variables) do
      add :key, :string
      add :value, :string
      add :owner, :string

      timestamps
    end
  end
end
