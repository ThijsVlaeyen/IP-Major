defmodule KatenhondWeb.UserController do
  use KatenhondWeb, :controller

  alias KatenhondWeb.Guardian
  alias Katenhond.UserContext
  alias Katenhond.UserContext.User

  def index(conn, _params) do
    users = UserContext.list_users()
    user = Guardian.Plug.current_resource(conn);
    render(conn, "index.html", users: users, loggedin: user)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password, "confirmpassword" => confirmpassword, "role" => role}}) do
    if(password != confirmpassword) do
      conn
      |> put_flash(:error, "Password did not match")
      |> render(conn, "new.html", changeset: UserContext.change_user(%User{}), acceptable_roles: UserContext.get_acceptable_roles())
    else 
      case UserContext.create_user({username, password, role}) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
