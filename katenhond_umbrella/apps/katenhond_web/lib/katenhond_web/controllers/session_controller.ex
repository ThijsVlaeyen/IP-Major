defmodule KatenhondWeb.SessionController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.UserContext
    alias Katenhond.UserContext.User

    # Login
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
      UserContext.authenticate_user(username, password)
      |> login_reply(conn)
    end
    
    def logout(conn, _) do
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/")
    end
    
    defp login_reply({:ok, user}, conn) do
      conn
      |> put_flash(:info, "Welcome #{user.username}!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/dashboard")
    end
    
    defp login_reply({:error, reason}, conn) do
      conn
      |> put_flash(:error, to_string(reason))
      |> newlogin(%{})
    end

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

    def signup(conn, %{"user" => user_params}) do
      case UserContext.create_user(user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Signed up successfully! Now please login!")
          |> redirect(to: "/login")
        {:error, %Ecto.Changeset{} = changeset} ->
          roles = getRolesForSignup()
          render(conn, "signup.html", changeset: changeset, acceptable_roles: roles, action: Routes.session_path(conn, :signup))
      end
    end

    defp getRolesForSignup() do
      ["User"]
    end

end