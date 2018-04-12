defmodule StiltzkeyWeb.PoemController do
  use StiltzkeyWeb, :controller

  import StiltzkeyWeb.AuthorHelper, only: [require_existing_author: 2]

  plug :require_existing_author
  plug :authorize_poem when action in [:edit, :update, :delete]

  alias Stiltzkey.Papyrus
  alias Stiltzkey.Papyrus.Poem

  def index(conn, _params) do
    poems = Papyrus.list_poems()
    render(conn, "index.html", poems: poems)
  end

  def new(conn, _params) do
    changeset = Papyrus.change_poem(%Poem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"poem" => poem_params}) do
    case Papyrus.create_poem(conn.assigns.current_author, poem_params) do
      {:ok, poem} ->
        conn
        |> put_flash(:info, "Poem created successfully.")
        |> redirect(to: poem_path(conn, :show, poem))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    poem = Papyrus.get_poem!(id)
    render(conn, "show.html", poem: poem)
  end

  def edit(conn, _) do
    changeset = Papyrus.change_poem(conn.assigns.poem)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"poem" => poem_params}) do
    case Papyrus.update_poem(conn.assigns.poem, poem_params) do
      {:ok, poem} ->
        conn
        |> put_flash(:info, "Poem updated successfully.")
        |> redirect(to: poem_path(conn, :show, poem))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _poem} = Papyrus.delete_poem(conn.assigns.poem)

    conn
    |> put_flash(:info, "Poem deleted successfully.")
    |> redirect(to: poem_path(conn, :index))
  end

  defp authorize_poem(conn, _) do
    poem = Papyrus.get_poem!(conn.params["id"])

    if conn.assigns.current_author.id == poem.author_id do
      assign(conn, :poem, poem)
    else
      conn
      |> put_flash(:error, "You can't modify that poem")
      |> redirect(to: poem_path(conn, :index))
      |> halt()
    end
  end
end
