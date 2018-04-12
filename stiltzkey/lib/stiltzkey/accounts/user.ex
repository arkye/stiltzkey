defmodule Stiltzkey.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Accounts.Credential

  schema "users" do
    field :username, :string
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
