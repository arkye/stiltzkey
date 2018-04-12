defmodule Stiltzkey.Repo.Migrations.AddAuthorIdToPoems do
  use Ecto.Migration

  def change do
    alter table(:poems) do
      add :author_id, references(:authors, on_delete: :delete_all),
                      null: false
    end

    create index(:poems, [:author_id])
  end
end
