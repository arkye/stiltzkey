defmodule Stiltzkey.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Stiltzkey.Accounts.{Credential, User}

  schema "credentials" do
    field :email, :string
    field :password, :string

    belongs_to :user, User

    timestamps()

    field :password_confirmation, :string, virtual: true
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, get_email_regex())
    |> validate_length(:email, min: 5, max: 50)
    |> validate_length(:password, min: 6, max: 40)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp get_email_regex do
    ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/
  end

  defp hash_password(%Changeset{} = changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Comeonin.Argon2.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
