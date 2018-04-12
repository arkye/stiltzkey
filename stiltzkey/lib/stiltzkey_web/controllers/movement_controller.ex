defmodule StiltzkeyWeb.MovementController do
  use StiltzkeyWeb, :controller

  import StiltzkeyWeb.LeaderHelper, only: [require_existing_leader: 2]

  plug :require_existing_leader
  plug :authorize_movement when action in [:edit, :update, :delete]

  alias Stiltzkey.Papyrus
  alias Stiltzkey.Papyrus.Movement

  def index(conn, _params) do
    movements = Papyrus.list_movements()
    render(conn, "index.html", movements: movements)
  end

  def new(conn, _params) do
    changeset = Papyrus.change_movement(%Movement{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"movement" => movement_params}) do
    case Papyrus.create_movement(conn.assigns.current_leader, movement_params) do
      {:ok, movement} ->
        conn
        |> put_flash(:info, "Movement created successfully.")
        |> redirect(to: movement_path(conn, :show, movement))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    movement = Papyrus.get_movement!(id)
    render(conn, "show.html", movement: movement)
  end

  def edit(conn, _) do
    changeset = Papyrus.change_movement(conn.assigns.movement)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"movement" => movement_params}) do
    case Papyrus.update_movement(conn.assigns.movement, movement_params) do
      {:ok, movement} ->
        conn
        |> put_flash(:info, "Movement updated successfully.")
        |> redirect(to: movement_path(conn, :show, movement))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _movement} = Papyrus.delete_movement(conn.assigns.movement)

    conn
    |> put_flash(:info, "Movement deleted successfully.")
    |> redirect(to: movement_path(conn, :index))
  end

  defp authorize_movement(conn, _) do
    movement = Papyrus.get_movement!(conn.params["id"])

    if conn.assigns.current_author.id == movement.author_id do
      assign(conn, :movement, movement)
    else
      conn
      |> put_flash(:error, "You can't modify that movement")
      |> redirect(to: movement_path(conn, :index))
      |> halt()
    end
  end
end
