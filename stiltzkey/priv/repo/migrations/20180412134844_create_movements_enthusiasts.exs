defmodule Stiltzkey.Repo.Migrations.CreateMovementsEnthusiasts do
  use Ecto.Migration

  def change do
    create table(:movements_enthusiasts) do
      add :enthusiast_id, references(:enthusiasts, on_delete: :delete_all),
                          null: false
      add :movement_id, references(:movements, on_delete: :delete_all),
                        null: false
    end

    create unique_index(:movements_enthusiasts, [:enthusiast_id, :movement_id])
  end

end
