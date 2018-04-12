defmodule Stiltzkey.Repo.Migrations.CreateMovements do
  use Ecto.Migration

  def change do
    create table(:movements) do
      add :name, :string
      add :description, :string
      add :leader_id, references(:leaders, on_delete: :delete_all),
                      null: false

      timestamps()
    end

    create index(:movements, [:leader_id])
  end
end
