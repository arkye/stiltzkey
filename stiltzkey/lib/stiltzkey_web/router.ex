defmodule StiltzkeyWeb.Router do
  use StiltzkeyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StiltzkeyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end

  scope "/papyrus", StiltzkeyWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/poems", PoemController
    resources "/poems/:poem_id/stanzas", StanzaController
    resources "/poems/:poem_id/stanzas/:stanza_id/verses", VerseController

    resources "/movements", MovementController
  end

  # Other scopes may use custom stacks.
  # scope "/api", StiltzkeyWeb do
  #   pipe_through :api
  # end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, Stiltzkey.Accounts.get_user!(user_id))
    end
  end
end
