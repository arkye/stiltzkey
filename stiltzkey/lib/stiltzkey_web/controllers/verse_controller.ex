defmodule StiltzkeyWeb.VerseController do
  use StiltzkeyWeb, :controller

  import StiltzkeyWeb.AuthorHelper, only: [require_existing_author: 2]

  plug :require_existing_author
  plug :require_stanza
  plug :authorize_verse when action in [:edit, :update, :delete]

  alias Stiltzkey.Papyrus
  alias Stiltzkey.Papyrus.Verse

  def index(conn, _params) do
    verses = Papyrus.list_verses()
    render(conn, "index.html", verses: verses)
  end

  def new(conn, _params) do
    changeset = Papyrus.change_verse(%Verse{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"verse" => verse_params}) do
    case Papyrus.create_verse(conn.assigns.current_author, conn.assigns.stanza, verse_params) do
      {:ok, verse} ->
        conn
        |> put_flash(:info, "Verse created successfully.")
        |> redirect(to: verse_path(conn, :show, conn.assigns.stanza.poem_id, conn.assigns.stanza.id, verse))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    verse = Papyrus.get_verse!(id)
    render(conn, "show.html", verse: verse)
  end

  def edit(conn, _) do
    changeset = Papyrus.change_verse(conn.assigns.verse)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"verse" => verse_params}) do
    case Papyrus.update_verse(conn.assigns.verse, verse_params) do
      {:ok, verse} ->
        conn
        |> put_flash(:info, "Verse updated successfully.")
        |> redirect(to: verse_path(conn, :show, conn.assigns.stanza.poem_id, conn.assigns.stanza.id, verse))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _verse} = Papyrus.delete_verse(conn.assigns.verse)

    conn
    |> put_flash(:info, "Verse deleted successfully.")
    |> redirect(to: verse_path(conn, :index, conn.assigns.stanza.poem_id, conn.assigns.stanza.id))
  end

  defp require_stanza(conn, _) do
    stanza = Papyrus.get_stanza!(conn.path_params["stanza_id"])
    assign(conn, :stanza, stanza)
  end

  defp authorize_verse(conn, _) do
    verse = Papyrus.get_verse!(conn.params["id"])

    if conn.assigns.current_author.id == verse.author_id do
      assign(conn, :verse, verse)
    else
      conn
      |> put_flash(:error, "You can't modify that verse")
      |> redirect(to: verse_path(conn, :index, conn.assigns.stanza.poem_id, conn.assigns.stanza.id))
      |> halt()
    end
  end
end
