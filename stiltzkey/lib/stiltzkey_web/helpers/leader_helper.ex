defmodule StiltzkeyWeb.LeaderHelper do
  import Plug.Conn

  def require_existing_leader(conn, _) do
    leader = Stiltzkey.Papyrus.ensure_leader_exists(conn.assigns.current_user)
    assign(conn, :current_leader, leader)
  end
end
