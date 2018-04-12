defmodule Stiltzkey.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Accounts.User

  schema "credentials" do
    field :email, :string
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end
end
