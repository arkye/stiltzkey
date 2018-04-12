defmodule Stiltzkey.Repo.Migrations.CreatePandoras do
  use Ecto.Migration

  def change do
    create table(:pandoras) do
      add :trouble, :string
      add :poem_id, references(:poems, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create index(:pandoras, [:poem_id])
  end
end
