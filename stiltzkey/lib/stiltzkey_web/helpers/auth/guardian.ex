defmodule StiltzkeyWeb.Helpers.Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :stiltzkey

  alias Stiltzkey.Accounts
  alias Stiltzkey.Accounts.User

  def subject_for_token(%User{id: id}, _claims) do
    subject = to_string(id)

    {:ok, subject}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accounts.get_user!(id)

    {:ok, user}
  end
end
