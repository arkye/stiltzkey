defmodule Stiltzkey.Papyrus.Verse do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Stiltzkey.Papyrus.{Author, Movement, Stanza, Verse}

  schema "verses" do
    field :key, :string
    field :value, :string

    belongs_to :author, Author
    belongs_to :stanza, Stanza

    many_to_many :movements, Movement, join_through: "movements_verses"

    timestamps()
  end

  @doc false
  def changeset(%Verse{} = verse, attrs) do
    verse
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> hash_value()
  end

  defp hash_value(%Changeset{} = changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{value: value}} ->
        put_change(changeset, :value, Cipher.encrypt(value))
      _ ->
        changeset
    end
  end
end
