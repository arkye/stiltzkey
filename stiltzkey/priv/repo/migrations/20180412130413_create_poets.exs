defmodule Stiltzkey.Repo.Migrations.CreatePoets do
  use Ecto.Migration

  def change do
    create table(:poets) do
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create unique_index(:poets, [:user_id])
  end
end
