defmodule Stiltzkey.Papyrus.Enthusiast do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.Movement

  schema "enthusiasts" do
    belongs_to :user, Stiltzkey.Accounts.User

    many_to_many :movements, Movement, join_through: "movements_enthusiasts"

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
