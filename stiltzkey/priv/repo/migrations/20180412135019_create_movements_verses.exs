defmodule Stiltzkey.Repo.Migrations.CreateMovementsVerses do
  use Ecto.Migration

  def change do
    create table(:movements_verses) do
      add :movement_id, references(:movements, on_delete: :delete_all),
                        null: false
      add :verse_id, references(:verses, on_delete: :delete_all),
                     null: false
    end

    create unique_index(:movements_verses, [:movement_id, :verse_id])
  end

end
