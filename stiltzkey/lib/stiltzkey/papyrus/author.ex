defmodule Stiltzkey.Papyrus.Author do
  use Ecto.Schema
  import Ecto.Changeset


  schema "authors" do
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
