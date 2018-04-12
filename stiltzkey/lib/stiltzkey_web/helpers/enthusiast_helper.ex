defmodule StiltzkeyWeb.EnthusiastHelper do
  import Plug.Conn

  def require_existing_enthusiast(conn, _) do
    enthusiast = Stiltzkey.Papyrus.ensure_enthusiast_exists(conn.assigns.current_user)
    assign(conn, :current_enthusiast, enthusiast)
  end
end
