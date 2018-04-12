defmodule StiltzkeyWeb.AuthorHelper do
  import Plug.Conn

  def require_existing_author(conn, _) do
    author = Stiltzkey.Papyrus.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end
end
