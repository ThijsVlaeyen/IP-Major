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

  #ADMIN CREATE NEW USER
  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password, "confirmpassword" => confirmpassword, "role" => role}}) do
    UserContext.create_user(username, password, confirmpassword, role)
    |> create_reply(conn)
  end

  defp create_reply({:ok}, conn) do
    conn
    |> put_flash(:info, "User created successfully!")
    |> redirect(to: "/management")
  end
    
  defp create_reply({:error, _reason}, conn) do
    conn
    |> put_flash(:error, to_string("Username is already taken"))
    |> new(%{})
  end

  defp create_reply({:warning, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end

end
