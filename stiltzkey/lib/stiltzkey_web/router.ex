defmodule StiltzkeyWeb.Router do
  use StiltzkeyWeb, :router

  import StiltzkeyWeb.Helpers.Plug.Accounts, only: [assign_user_if_exists: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug StiltzkeyWeb.Helpers.Locale.Plug, "pt"
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

    resources "/poems", PoemController
    resources "/poems/:poem_id/stanzas", StanzaController
    resources "/poems/:poem_id/stanzas/:stanza_id/verses", VerseController
    get "/poems/:poem_id/stanzas/:stanza_id/verses/:id/value", VerseController, :show_value

    resources "/movements", MovementController
    get "/movements/:id/verse/:verse_id/value", MovementController, :show_value
    post "/movements/:id/poet", MovementController, :add_poet
    post "/movements/:id/enthusiast", MovementController, :add_enthusiast
    post "/movements/:id/verse", MovementController, :add_verse
  end
end
