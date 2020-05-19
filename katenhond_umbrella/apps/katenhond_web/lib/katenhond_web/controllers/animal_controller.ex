defmodule KatenhondWeb.AnimalController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.UserContext
    alias Katenhond.AnimalContext
    alias Katenhond.AnimalContext.Animal
    alias Katenhond.KeyContext
    alias Katenhond.KeyContext.Key
    require Logger

    def index(conn, %{"user_id" => user_id}) do
        user = UserContext.get_user!(user_id)
        if authenticate(conn, user) do
            user_with_loaded_animals = AnimalContext.load_animals(user)
            render(conn, "index.json", animals: user_with_loaded_animals.animals)
        end
    end
    
    def show(conn, %{"id" => id}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, animal.user) do
            render(conn, "show.json", animal: animal)
        end
    end

    def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
        user = UserContext.get_user!(user_id)
        if authenticate(conn, user) do
            case AnimalContext.create_animal(animal_params, user) do
                {:ok, %Animal{} = animal} ->
                    conn
                    |> put_status(:created)
                    |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
                    |> render("show.json", animal: animal)
    
                {:error, _changeset} ->
                    conn
                    |> send_resp(400, "Idk tbh change your parameters or something")
            end
        end
    end

    def update(conn, %{"id" => id,"animal" => animal_params}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, animal.user) do
            case AnimalContext.update_animal(animal, animal_params) do
                {:ok, %Animal{} = animal} ->
                    render(conn,"show.json",animal: animal)
    
                {:error, _cs} ->
                    conn
                    |> send_resp(400,"Something went wrong, sorry. Adjust your parameters or give up.")
            end
        end
    end

    def delete(conn, %{"id" => id}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, animal.user) do
            case AnimalContext.delete_animal(animal) do
                {:ok, _animal} ->
                    conn
                    |> send_resp(400, "Animal deleted")
                {:error, _changeset} ->
                    conn
                    |> send_resp(400, "Something went wrong.")
            end
        end
    end

    def authenticate(conn, user) do
        if (user != nil) do
            user = KeyContext.load_keys(user)
            api_key = get_req_header(conn, "x-api-key")
            Logger.debug "Keys value: #{inspect(api_key)}"
            keys = Enum.map(user.keys, fn x -> x.value end)
            IO.inspect(keys)
            if (!Enum.any?(keys, fn x -> String.equivalent?(x, api_key) end)) do
                conn
                |> send_resp(401, "unauthorized")
                false
            else
                true
            end
        else
            conn
            |> put_status(:not_found)
            |> send_resp(404, "user not found")
            false
        end
    end

end