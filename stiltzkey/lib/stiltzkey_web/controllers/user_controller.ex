defmodule StiltzkeyWeb.UserController do
  use StiltzkeyWeb, :controller

  alias Stiltzkey.Accounts
  alias Stiltzkey.Accounts.{User, Credential}
  alias Stiltzkey.Papyrus
  alias StiltzkeyWeb.SessionController

  plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Papyrus.create_author(user)
        Papyrus.create_enthusiast(user)
        Papyrus.create_leader(user)
        Papyrus.create_poet(user)

        conn
        |> SessionController.create(to_session(user_params))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp to_session(user_params) do
    credential = user_params["credential"]
    %{
      "user" => %{
        "email" => credential["email"],
        "password" => credential["password"]
      }
    }
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, _) do
    changeset = conn.assigns.current_user |> Accounts.change_user()
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => params}) do
    credential = conn.assigns.current_user.credential
    case validate_password(credential, params["credential"]) do
      %User{} = user ->
        case Accounts.update_user(user, params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, gettext("User updated successfully."))
            |> redirect(to: user_path(conn, :show, user))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, gettext("Password invalid."))
        |> redirect(to: user_path(conn, :edit, conn.assigns.current_user.id))
    end
  end

  defp validate_password(%Credential{email: email}, %{"password" => password}) do
    Accounts.authenticate_by_email_password(email, password)
  end

  defp validate_password(_, _) do
    {:error, :unauthorized}
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: user_path(conn, :index))
  end

  defp authorize_user(%{params: %{"id" => id}} = conn, _) do
    if conn.assigns.current_user.id == String.to_integer(id) do
      case conn.assigns do
        %{user: _user} -> conn
        _ -> assign(conn, :user, conn.assigns.current_user)
      end
    else
      conn
      |> put_flash(:error, gettext("You can't modify that user."))
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
