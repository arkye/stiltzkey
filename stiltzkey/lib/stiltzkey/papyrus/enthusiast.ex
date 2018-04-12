defmodule Stiltzkey.Papyrus.Enthusiast do
  use Ecto.Schema
  import Ecto.Changeset

  schema "enthusiasts" do
    belongs_to :user, Stiltzkey.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(enthusiast, attrs) do
    enthusiast
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
