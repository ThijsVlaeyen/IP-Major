defmodule KatenhondWeb.Router do
  use KatenhondWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KatenhondWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  # Authentication
  pipeline :auth do
    plug KatenhondWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end


  # Allowed for ...
  pipeline :allowed_for_users do
    plug KatenhondWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug KatenhondWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  #API CHECK
  pipeline :read do
    plug KatenhondWeb.Plugs.PermissionPlug, [true, false]
  end

  pipeline :readwrite do
    plug KatenhondWeb.Plugs.PermissionPlug, [true]
  end

  # Everyone
  scope "/", KatenhondWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/noaccess", PageController, :noaccess
    get "/login", SessionController, :newlogin
    post "/login", SessionController, :login
    get "/signup", SessionController, :newsignup
    post "/signup", SessionController, :signup
    get "/logout", SessionController, :logout
  end

  # User pages
  scope "/", KatenhondWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/dashboard", PageController, :dashboard
    
    scope "/profile" do
      get "/", ProfileController, :profile
      scope "/edit" do
        get "/username", ProfileController, :changeusername
        put "/username", ProfileController, :changeusernamepost
        get "/password", ProfileController, :changepassword
        put "/password", ProfileController, :changepasswordpost
      end
      scope "/api" do
        post "/new", KeyController, :new
        get "/show/:id", KeyController, :show
        delete "/delete/:id", KeyController, :delete
      end
    end

  end

  # Admin pages
  scope "/", KatenhondWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    get "/management", PageController, :management
    resources "/users", UserController

    get "/apikeys", PageController, :apikeys
    resources "/admin/apikeys/overview", KeyController
  end

  # API
  #READ
  scope "/api", KatenhondWeb do
    pipe_through [:api, :read]

    # Animals for Users
    resources "/users", UserController, only: [] do
      get "/animals", AnimalController, :index
      get "/animals/:id", AnimalController, :show
    end

   end

   scope "/api", KatenhondWeb do
    pipe_through [:api, :readwrite]

    # Animals for Users
    resources "/users", UserController, only: [] do
      post "/animals", AnimalController, :create
      put "/animals/:id", AnimalController, :update
      delete "/animals/:id", AnimalController, :delete
    end
   end

end
