defmodule StiltzkeyWeb.StanzaController do
  use StiltzkeyWeb, :controller

  import StiltzkeyWeb.Helpers.Plug.Papyrus, only: [assign_author: 2]

  plug :assign_author
  plug :require_poem
  plug :require_poem_ownership when action in [:index]
  plug :authorize_if_author when action in [:show, :edit, :update, :delete]

  alias Stiltzkey.Papyrus
  alias Stiltzkey.Papyrus.Stanza

  def index(conn, _params) do
    stanzas = Papyrus.list_stanzas_from_poem(conn.assigns.poem)
    render(conn, "index.html", stanzas: stanzas)
  end

  def new(conn, _params) do
    changeset = Papyrus.change_stanza(%Stanza{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"stanza" => stanza_params}) do
    case Papyrus.create_stanza(conn.assigns.current_author, conn.assigns.poem, stanza_params) do
      {:ok, stanza} ->
        conn
        |> put_flash(:info, gettext("Stanza created successfully."))
        |> redirect(to: stanza_path(conn, :show, conn.assigns.poem.id, stanza))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stanza = Papyrus.get_stanza!(id)
    render(conn, "show.html", stanza: stanza)
  end

  def edit(conn, _) do
    changeset = Papyrus.change_stanza(conn.assigns.stanza)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"stanza" => stanza_params}) do
    case Papyrus.update_stanza(conn.assigns.stanza, stanza_params) do
      {:ok, stanza} ->
        conn
        |> put_flash(:info, gettext("Stanza updated successfully."))
        |> redirect(to: stanza_path(conn, :show, conn.assigns.poem.id, stanza))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _stanza} = Papyrus.delete_stanza(conn.assigns.stanza)

    conn
    |> put_flash(:info, gettext("Stanza deleted successfully."))
    |> redirect(to: stanza_path(conn, :index, conn.assigns.poem.id))
  end

  defp require_poem(conn, _) do
    poem = Papyrus.get_poem!(conn.path_params["poem_id"])
    assign(conn, :poem, poem)
  end

  defp require_poem_ownership(conn, _) do
    if conn.assigns.poem.author_id == conn.assigns.current_author.id do
      conn
    else
      conn
      |> put_flash(:error, gettext("You can't see that stanzas."))
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_if_author(conn, _) do
    stanza = Papyrus.get_stanza!(conn.params["id"])

    if conn.assigns.current_author.id == stanza.author_id do
      assign(conn, :stanza, stanza)
    else
      conn
      |> put_flash(:error, gettext("You can't see or modify that stanza."))
      |> redirect(to: stanza_path(conn, :index, conn.assigns.poem.id))
      |> halt()
    end
  end
end
