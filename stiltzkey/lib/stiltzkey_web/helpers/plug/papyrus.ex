defmodule StiltzkeyWeb.Helpers.Plug.Papyrus do
  import Plug.Conn

  alias Stiltzkey.Papyrus

  def assign_author(conn, _) do
    author = Papyrus.get_author_by_user!(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  def assign_enthusiast(conn, _) do
    enthusiast = Papyrus.get_enthusiast_by_user!(conn.assigns.current_user)
    assign(conn, :current_enthusiast, enthusiast)
  end

  def assign_leader(conn, _) do
    leader = Papyrus.get_leader_by_user!(conn.assigns.current_user)
    assign(conn, :current_leader, leader)
  end

  def assign_poet(conn, _) do
    poet = Papyrus.get_poet_by_user!(conn.assigns.current_user)
    assign(conn, :current_poet, poet)
  end
end
