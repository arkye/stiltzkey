defmodule Stiltzkey.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:authors, [:user_id])
  end
end
