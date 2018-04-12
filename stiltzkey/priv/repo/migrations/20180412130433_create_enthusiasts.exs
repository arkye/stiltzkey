defmodule Stiltzkey.Repo.Migrations.CreateEnthusiasts do
  use Ecto.Migration

  def change do
    create table(:enthusiasts) do
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create unique_index(:enthusiasts, [:user_id])
  end
end
