defmodule StiltzkeyWeb.UserHelper do
  import Plug.Conn

  alias StiltzkeyWeb.Helpers.Auth.Guardian

  def assign_user_if_exists(conn, _) do
    conn
    |> maybe_assign_user()
  end

  defp maybe_assign_user(conn) do
    case Guardian.Plug.current_resource(conn) do
      %Stiltzkey.Accounts.User{} = user -> assign(conn, :current_user, user)
      _ -> conn
    end
  end
end
