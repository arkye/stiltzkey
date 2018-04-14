defmodule StiltzkeyWeb.Router do
  use StiltzkeyWeb, :router

  import StiltzkeyWeb.UserHelper, only: [assign_user_if_exists: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :maybe_user do
    plug StiltzkeyWeb.Helpers.Auth.AccessPipeline
    plug :assign_user_if_exists
  end

  pipeline :authenticate do
    plug StiltzkeyWeb.Helpers.Auth.EnsureAccessPipeline
    plug :assign_user_if_exists
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StiltzkeyWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end

  scope "/", StiltzkeyWeb do
    pipe_through [:browser, :maybe_user]

    get "/", PageController, :index
  end

  scope "/profile", StiltzkeyWeb do
    pipe_through [:browser, :authenticate]
    
    resources "/", UserController, only: [:show, :edit, :update, :delete]
  end

  scope "/papyrus", StiltzkeyWeb do
    pipe_through [:browser, :authenticate]

    resources "/movements", MovementController
    resources "/poems", PoemController
    resources "/poems/:poem_id/stanzas", StanzaController
    resources "/poems/:poem_id/stanzas/:stanza_id/verses", VerseController
  end

  # Other scopes may use custom stacks.
  # scope "/api", StiltzkeyWeb do
  #   pipe_through :api
  # end
end
