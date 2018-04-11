defmodule Stiltzkey.Repo.Migrations.CreateStanzas do
  use Ecto.Migration

  def change do
    create table(:stanzas) do
      add :context, :string
      add :description, :string
      add :author_id, references(:authors, on_delete: :delete_all),
                      null: false
      add :poem_id, references(:poems, on_delete: :delete_all),
                      null: false

      timestamps()
    end

    create index(:stanzas, [:author_id])
    create index(:stanzas, [:poem_id])
  end
end
