defmodule StiltzkeyWeb.PoemController do
  use StiltzkeyWeb, :controller

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
    case Papyrus.create_poem(poem_params) do
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

  def edit(conn, %{"id" => id}) do
    poem = Papyrus.get_poem!(id)
    changeset = Papyrus.change_poem(poem)
    render(conn, "edit.html", poem: poem, changeset: changeset)
  end

  def update(conn, %{"id" => id, "poem" => poem_params}) do
    poem = Papyrus.get_poem!(id)

    case Papyrus.update_poem(poem, poem_params) do
      {:ok, poem} ->
        conn
        |> put_flash(:info, "Poem updated successfully.")
        |> redirect(to: poem_path(conn, :show, poem))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", poem: poem, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    poem = Papyrus.get_poem!(id)
    {:ok, _poem} = Papyrus.delete_poem(poem)

    conn
    |> put_flash(:info, "Poem deleted successfully.")
    |> redirect(to: poem_path(conn, :index))
  end
end
