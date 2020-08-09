defmodule KatenhondWeb.SessionController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.UserContext
    alias Katenhond.UserContext.User

    # LOGIN
    # ==========
    def newlogin(conn, _) do
      changeset = UserContext.change_user(%User{})
      maybe_user = Guardian.Plug.current_resource(conn)
    
      if maybe_user do
        redirect(conn, to: "/dashboard")
      else
        render(conn, "login.html", changeset: changeset, action: Routes.session_path(conn, :login))
      end
    end
    
    def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
      case UserContext.authenticate_user(username, password) do
        {:ok, user} ->
          conn
          |> put_flash(:info, gettext("Welcome!"))
          |> Guardian.Plug.sign_in(user)
          |> redirect(to: "/dashboard")
        {:error, :invalid_credentials} ->
          conn
          |> put_flash(:error, gettext("Invalid credentials"))
          |> newlogin(%{})
      end
    end
    
    def logout(conn, _) do
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/")
    end

    # CREATING NEW USER
    # ==========
    def newsignup(conn,_) do
      maybe_user = Guardian.Plug.current_resource(conn)
      if maybe_user do
        conn
        |> put_flash(:error, "You have to log out before you can signup someone new!")
        |> redirect(to: "/dashboard")
      else
        changeset = UserContext.change_user(%User{})
        roles = getRolesForSignup()
        render(conn, "signup.html", changeset: changeset, acceptable_roles: roles, action: Routes.session_path(conn, :signup))
      end
    end

    def signup(conn, %{"user" => %{"username" => username, "password" => password, "confirmpassword" => confirmpassword}}) do
      case UserContext.create_user(username, password, confirmpassword, "User") do
        {:ok, _t} ->
          conn
          |> put_flash(:info, gettext("Signed up successfully! Now please login!"))
          |> redirect(to: "/login")
        {:error, :passwords_do_not_match} ->
          conn
          |> put_flash(:error, gettext("Passwords do not match"))
          |> newsignup(%{})
        {:error, _t} ->
          conn
          |> put_flash(:error, gettext("Username already taken"))
          |> newsignup(%{})
      end
    end

    defp getRolesForSignup() do
      ["User"]
    end

end