defmodule Stiltzkey.Repo.Migrations.CreateLeaders do
  use Ecto.Migration

  def change do
    create table(:leaders) do
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create unique_index(:leaders, [:user_id])
  end
end
