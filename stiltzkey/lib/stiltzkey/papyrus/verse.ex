defmodule Stiltzkey.Papyrus.Verse do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.{Author, Stanza}

  schema "verses" do
    field :key, :string
    field :value, :string

    belongs_to :author, Author
    belongs_to :stanza, Stanza

    timestamps()
  end

  @doc false
  def changeset(verse, attrs) do
    verse
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
