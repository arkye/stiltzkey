defmodule Stiltzkey.Papyrus.Poem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.Author

  schema "poems" do
    field :description, :string
    field :title, :string

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(poem, attrs) do
    poem
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
