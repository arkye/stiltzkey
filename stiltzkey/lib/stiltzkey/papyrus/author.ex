defmodule Stiltzkey.Papyrus.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.Poem

  schema "authors" do
    has_many :poems, Poem
    belongs_to :user, Stiltzkey.Accounts.User

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
