defmodule Stiltzkey.Repo.Migrations.CreateMovementsPoets do
  use Ecto.Migration

  def change do
    create table(:movements_poets) do
      add :movement_id, references(:movements, on_delete: :delete_all),
                        null: false
      add :poet_id, references(:poets, on_delete: :delete_all),
                    null: false
    end

    create unique_index(:movements_poets, [:movement_id, :poet_id])
  end

end
