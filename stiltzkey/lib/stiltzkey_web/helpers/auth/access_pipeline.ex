defmodule StiltzkeyWeb.Helpers.Auth.AccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :stiltzkey

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource, ensure: false, allow_blank: true
end
