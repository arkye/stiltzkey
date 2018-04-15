defmodule StiltzkeyWeb.SessionController do
  use StiltzkeyWeb, :controller

  alias StiltzkeyWeb.Helpers.Auth.Guardian
  alias Stiltzkey.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      %Accounts.User{} = user ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Welcome #{user.username}!")
        |> redirect(to: page_path(conn, :index))
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :index))
  end
end
