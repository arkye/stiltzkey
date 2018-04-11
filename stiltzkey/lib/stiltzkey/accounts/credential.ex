defmodule Stiltzkey.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset


  schema "credentials" do
    field :email, :string
    field :password, :string
    field :user_id, :id

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
