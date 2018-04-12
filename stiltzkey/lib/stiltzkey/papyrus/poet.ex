defmodule Stiltzkey.Papyrus.Poet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.Movement

  schema "poets" do
    belongs_to :user, Stiltzkey.Accounts.User

    many_to_many :movements, Movement, join_through: "movements_poets"

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
