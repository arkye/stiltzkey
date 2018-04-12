defmodule Stiltzkey.Repo.Migrations.CreatePoems do
  use Ecto.Migration

  def change do
    create table(:poems) do
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
