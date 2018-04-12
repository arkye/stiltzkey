defmodule Stiltzkey.Papyrus.Pandora do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.Poem

  schema "pandoras" do
    field :trouble, :string

    belongs_to :poem, Poem

    timestamps()
  end

  @doc false
  def changeset(pandora, attrs) do
    pandora
    |> cast(attrs, [:trouble])
    |> validate_required([:trouble])
  end
end
