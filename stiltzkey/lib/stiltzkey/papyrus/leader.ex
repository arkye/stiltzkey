defmodule Stiltzkey.Papyrus.Leader do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.{Movement}

  schema "leaders" do
    belongs_to :user, Stiltzkey.Accounts.User

    has_many :movements, Movement

    timestamps()
  end

  @doc false
  def changeset(leader, attrs) do
    leader
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
