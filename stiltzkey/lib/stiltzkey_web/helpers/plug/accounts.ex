defmodule StiltzkeyWeb.Helpers.Plug.Accounts do
  import Plug.Conn

  alias StiltzkeyWeb.Helpers.Auth.Guardian
  alias Stiltzkey.Accounts

  def assign_user_if_exists(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      %Accounts.User{} = user -> assign(conn, :current_user, user)
      _ -> Guardian.Plug.sign_out(conn)
    end
  end
end
