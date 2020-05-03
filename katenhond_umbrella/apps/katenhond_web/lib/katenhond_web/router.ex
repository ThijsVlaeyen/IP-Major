defmodule KatenhondWeb.Router do
  use KatenhondWeb, :router

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

  pipeline :auth do
    plug KatenhondWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug KatenhondWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug KatenhondWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  #Iedereen
  scope "/", KatenhondWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/users/new", UserController, :new
    post "/users", UserController, :create
  end

  #User & Admin
  scope "/", KatenhondWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/home", PageController, :home

    get "/user_scope", PageController, :user_index

    scope "/profile" do
      get "/", ProfileController, :profile
    end
  end

  #Admin
  scope "/admin", KatenhondWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", KatenhondWeb do
  #   pipe_through :api
  # end
end
