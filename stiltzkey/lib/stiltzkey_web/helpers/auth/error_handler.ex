defmodule StiltzkeyWeb.Helpers.Auth.ErrorHandler do
  @moduledoc false

  import Plug.Conn
  import StiltzkeyWeb.Router.Helpers

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> maybe_put_error_flash()
    |> Phoenix.Controller.redirect(to: page_path(conn, :index))
    |> halt()
  end

  defp maybe_put_error_flash(%{request_path: "/"} = conn), do: conn
  defp maybe_put_error_flash(%{request_path: "/about"} = conn), do: conn

  defp maybe_put_error_flash(conn) do
    Phoenix.Controller.put_flash(conn, :error, "You're not authenticated")
  end
end
