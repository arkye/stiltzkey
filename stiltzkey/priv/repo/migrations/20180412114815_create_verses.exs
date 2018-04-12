defmodule Stiltzkey.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def change do
    create table(:verses) do
      add :key, :string
      add :value, :string
      add :stanza_id, references(:stanzas, on_delete: :delete_all),
                      null: false
      add :author_id, references(:authors, on_delete: :delete_all),
                      null: false

      timestamps()
    end

    create index(:verses, [:stanza_id])
    create index(:verses, [:author_id])
  end
end
