defmodule StiltzkeyWeb.MovementController do
  use StiltzkeyWeb, :controller

  import StiltzkeyWeb.Helpers.Plug.Papyrus, only: [
    assign_author: 2,
    assign_enthusiast: 2,
    assign_leader: 2,
    assign_poet: 2,
  ]

  plug :assign_author
  plug :assign_leader
  plug :assign_poet
  plug :assign_enthusiast
  plug :authorize_role when action not in [
    :index, :new, :create, :delete
  ]
  plug :authorize_if_leader when action in [
    :edit, :update, :delete, :add_poet, :add_enthusiast
  ]
  plug :authorize_if_poet when action in [
    :add_verse
  ]
  plug :refuse_if_blank when action in [
    :add_poet, :add_enthusiast
  ]
  plug :refuse_if_self when action in [
    :add_poet, :add_enthusiast
  ]
  plug :refuse_if_already_set when action in [
    :add_poet, :add_enthusiast
  ]

  alias Stiltzkey.Papyrus
  alias Stiltzkey.Papyrus.{Enthusiast, Movement, Poet, Verse}

  def index(conn, _params) do
    movements = Papyrus.list_movements_from_leader(conn.assigns.current_leader)
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

  def show(conn, _) do
    poet = Papyrus.change_poet(%Poet{})
    enthusiast = Papyrus.change_enthusiast(%Enthusiast{})
    verse = Papyrus.change_verse(%Verse{})

    my_verses = Papyrus.list_verses_from_author(conn.assigns.current_author) -- conn.assigns.movement.verses
    |> Enum.map(&{"#{&1.key}", &1.id})

    conn
    |> assign(:my_verses, my_verses)
    |> render("show.html", poet: poet, enthusiast: enthusiast, verse: verse)
  end

  def show_value(conn, %{"verse_id" => id}) do
    poet = Papyrus.change_poet(%Poet{})
    enthusiast = Papyrus.change_enthusiast(%Enthusiast{})
    verse = Papyrus.change_verse(%Verse{})

    my_verses = Papyrus.list_verses_from_author(conn.assigns.current_author) -- conn.assigns.movement.verses
    |> Enum.map(&{"#{&1.key}", &1.id})

    id  = String.to_integer(id)
    verse_to_show = Enum.find(conn.assigns.movement.verses, fn(verse) ->
      verse.id == id
    end)

    conn
    |> assign(:my_verses, my_verses)
    |> put_flash(:info, Cipher.decrypt(verse_to_show.value))
    |> render("show.html", poet: poet, enthusiast: enthusiast, verse: verse)
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

  def add_poet(conn, _params) do
    poet = Papyrus.get_poet_by_username!(conn.assigns.requested_username)
    case Papyrus.add_poet_to_movement(conn.assigns.movement, poet) do
      {:ok, movement} ->
        conn
        |> put_flash(:info, "Poet successfully joined the Movement")
        |> redirect(to: movement_path(conn, :show, movement))
      _error ->
        conn
        |> put_flash(:error, "Poet failed to join the Movement")
        |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
    end
  end

  def add_enthusiast(conn, _params) do
    enthusiast = Papyrus.get_enthusiast_by_username!(conn.assigns.requested_username)
    case Papyrus.add_enthusiast_to_movement(conn.assigns.movement, enthusiast) do
      {:ok, movement} ->
        conn
        |> put_flash(:info, "Enthusiast successfully joined the Movement")
        |> redirect(to: movement_path(conn, :show, movement))
      _error ->
        conn
        |> put_flash(:error, "Enthusiast failed to join the Movement")
        |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
    end
  end

  def add_verse(conn, %{"verse" => %{"id" => id}}) do
    verse = Papyrus.get_verse!(id)
    case Papyrus.add_verse_to_movement(conn.assigns.movement, verse) do
      {:ok, movement} ->
        conn
        |> put_flash(:info, "Verse successfully inserted in the Movement")
        |> redirect(to: movement_path(conn, :show, movement))
      _error ->
        conn
        |> put_flash(:error, "Verse failed to be inserted in the Movement")
        |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
    end
  end

  defp authorize_role(conn, _) do
    movement = Papyrus.get_movement!(conn.params["id"])
    cond do
      conn.assigns.current_leader.id == movement.leader_id ->
        conn
        |> assign(:movement, movement)
        |> assign(:role, :leader)
      Enum.member?(movement.poets, conn.assigns.current_poet) ->
        conn
        |> assign(:movement, movement)
        |> assign(:role, :poet)
      Enum.member?(movement.enthusiasts, conn.assigns.current_enthusiast) ->
        conn
        |> assign(:movement, movement)
        |> assign(:role, :enthusiast)
      true ->
        conn
        |> put_flash(:error, "You are not part of the movement")
        |> redirect(to: movement_path(conn, :index))
        |> halt()
    end
  end

  defp authorize_if_leader(conn, _) do
    movement = Papyrus.get_movement!(conn.params["id"])

    if conn.assigns.role == :leader do
      assign(conn, :movement, movement)
    else
      conn
      |> put_flash(:error, "You can't modify that movement")
      |> redirect(to: movement_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_if_poet(conn, _) do
    movement = Papyrus.get_movement!(conn.params["id"])

    if conn.assigns.role == :leader or conn.assigns.role == :poet do
      assign(conn, :movement, movement)
    else
      conn
      |> put_flash(:error, "You can't modify that movement")
      |> redirect(to: movement_path(conn, :index))
      |> halt()
    end
  end

  defp refuse_if_blank(conn, _params) do
    conn = case conn.params do
      %{"poet" => %{"username" => username}} ->
        conn
        |> assign(:requested_username, username)
      %{"enthusiast" => %{"username" => username}} ->
        conn
        |> assign(:requested_username, username)
      _ -> conn
    end

    if String.length(conn.assigns.requested_username) == 0 do
      conn
      |> put_flash(:error, "Inform the username first")
      |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
      |> halt()
    else
      conn
    end
  end

  defp refuse_if_self(conn, _params) do
    if conn.assigns.requested_username == conn.assigns.current_user.username do
      conn
      |> put_flash(:error, "You can't add yourself")
      |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
      |> halt()
    else
      conn
    end
  end

  defp refuse_if_already_set(conn, _params) do
    try do
      username = conn.assigns.requested_username
      for poet <- conn.assigns.movement.poets do
        if poet.user.username == username, do: raise "same"
      end
      for enthusiast <- conn.assigns.movement.enthusiasts do
        if enthusiast.user.username == username, do: raise "same"
      end
      conn
    rescue
      _ ->
        conn
        |> put_flash(:error, "User already joined the movement")
        |> redirect(to: movement_path(conn, :show, conn.assigns.movement))
        |> halt()
    end
  end
end
