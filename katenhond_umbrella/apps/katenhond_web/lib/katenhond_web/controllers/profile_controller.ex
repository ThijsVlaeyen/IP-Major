defmodule KatenhondWeb.ProfileController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.UserContext
    alias Katenhond.KeyContext
    alias Katenhond.KeyContext.Key

    # Huidige ingelogde gebruiker
    defp getUser(conn), do: Guardian.Plug.current_resource(conn);

    # Profile page
    def profile(conn,_params) do
        user = getUser(conn)
        user_with_loaded_keys = KeyContext.load_keys(user)
        keys_of_loggedin_user = user_with_loaded_keys.keys
        changeset = KeyContext.change_key(%Key{})
        render(conn,"profile.html", user: user, keys: keys_of_loggedin_user, changeset: changeset)
    end

    # Change username
    def changeusername(conn,_params) do
        user = getUser(conn)
        changeset = UserContext.change_user(user)
        render(conn,"editusername.html", user: user, changeset: changeset)
    end

    def changeusernamepost(conn,%{"user" => %{"username" => username}}) do
        user = getUser(conn)
        case UserContext.change_username(user,username) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, gettext("Changed username successfully"))
            |> redirect(to: "/profile")
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn,"editusername.html", user: user, changeset: changeset)
        end
    end

    # Change password
    def changepassword(conn,_params) do
        user = getUser(conn)
        changeset = UserContext.change_user(user)
        render(conn,"editpassword.html", user: user, changeset: changeset)
    end

    def changepasswordpost(conn,%{"user" => %{"oldpassword" => oldpassword,"newpassword" => newpassword, "confirmnewpassword" => confirmnewpassword}}) do
        user = getUser(conn)
        case UserContext.change_password(user,oldpassword,newpassword, confirmnewpassword) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, gettext("Changed password successfully!"))
            |> redirect(to: "/profile")
          {:error, :invalid_credentials} ->
            conn
            |> put_flash(:error, gettext("Old password is not correct"))
            |> render("editpassword.html", user: user, changeset: UserContext.change_user(user))
          {:error, :non_matching} ->
            conn
            |> put_flash(:error, gettext("Passwords do not match"))
            |> render("editpassword.html", user: user, changeset: UserContext.change_user(user))
        end
    end

end