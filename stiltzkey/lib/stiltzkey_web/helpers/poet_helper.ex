defmodule StiltzkeyWeb.PoetHelper do
  import Plug.Conn

  def require_existing_poet(conn, _) do
    poet = Stiltzkey.Papyrus.ensure_poet_exists(conn.assigns.current_user)
    assign(conn, :current_poet, poet)
  end
end
