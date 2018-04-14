defmodule StiltzkeyWeb.Helpers.Auth.EnsureAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :stiltzkey

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
