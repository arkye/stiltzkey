defmodule Stiltzkey.Papyrus.Stanza do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.{Author, Poem, Verse}

  schema "stanzas" do
    field :context, :string
    field :description, :string

    has_many :verses, Verse

    belongs_to :author, Author
    belongs_to :poem, Poem

    timestamps()
  end

  @doc false
  def changeset(stanza, attrs) do
    stanza
    |> cast(attrs, [:context, :description])
    |> validate_required([:context, :description])
  end
end
