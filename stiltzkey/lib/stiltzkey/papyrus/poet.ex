defmodule Stiltzkey.Papyrus.Poet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "poets" do
    belongs_to :user, Stiltzkey.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(poet, attrs) do
    poet
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
