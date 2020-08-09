defmodule KatenhondWeb.KeyController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.KeyContext
    require Logger

    # Huidige ingelogde gebruiker
    defp getUser(conn), do: Guardian.Plug.current_resource(conn);

    # Nieuwe API key
    def new(conn,%{"key" => %{"name" => name, "is_writeable" => permission}}) do
        user = getUser(conn)
        case KeyContext.create_key(name, permission, user) do
          {:ok, key} ->
            conn
            |> put_flash(:info, "Key #{key.name} succesfully generated!")
            |> redirect(to: "/profile")
          {:error, %Ecto.Changeset{} = _changeset} ->
            conn
            |> put_flash(:error, "Key failed to generate :/")
            |> redirect(to: "/profile")
        end
    end
  
    # API Key displayen
    def show(conn, %{"id" => id}) do
        key = KeyContext.get_key!(id) 
        case key.user.id == Guardian.Plug.current_resource(conn).id do
            true ->
                conn
                |> render("key.json", key: key)
            false ->
                conn
                |> put_flash(:error, "No access")
        end
    end
  
    # API Key deleten
    def delete(conn, %{"id" => id}) do
        key = KeyContext.get_key!(id)
        case key.user.id == Guardian.Plug.current_resource(conn).id do
            true ->
                case KeyContext.delete_key(key) do
                    {:ok, _key} ->
                        conn
                        |> put_flash(:info, "Succesfully Deleted!")
                        |> redirect(to: "/profile")
                    _ ->
                        conn
                        |> put_flash(:error, "Failed to delete!")
                        |> redirect(to: "/profile")
                end
            false ->
                conn
                |> put_flash(:error, "No access")
        end
        
    end

end