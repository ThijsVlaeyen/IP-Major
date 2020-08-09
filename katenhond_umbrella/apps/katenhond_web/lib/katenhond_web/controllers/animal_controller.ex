defmodule KatenhondWeb.AnimalController do
    use KatenhondWeb, :controller

    alias Katenhond.UserContext
    alias Katenhond.AnimalContext
    alias Katenhond.AnimalContext.Animal
    alias Katenhond.KeyContext
    require Logger

    def index(conn, %{"user_id" => user_id}) do
        user = UserContext.get_user!(user_id)
        if authenticate(conn, user_id) do
            user_with_loaded_animals = AnimalContext.load_animals(user)
            render(conn, "index.json", animals: user_with_loaded_animals.animals)
        end
    end
    
    def show(conn, %{"id" => id, "user_id" => user_id}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, user_id) do
            render(conn, "show.json", animal: animal)
        end
    end

    def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
        user = UserContext.get_user!(user_id)
        if authenticate(conn, user.id) do
            case AnimalContext.create_animal(animal_params, user) do
                {:ok, %Animal{} = animal} ->
                    conn
                    |> put_status(:created)
                    |> render("show.json", animal: animal)
                _ ->
                    conn
                    |> send_resp(400, "Idk tbh change your parameters or something")
            end
        end
    end

    def update(conn, %{"user_id" => user_id, "id" => id,"animal" => animal_params}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, user_id) do
            case AnimalContext.update_animal(animal, animal_params) do
                {:ok, %Animal{} = animal} ->
                    render(conn,"show.json",animal: animal)
                _ ->
                    conn
                    |> send_resp(400,"Something went wrong, sorry. Adjust your parameters or give up.")
            end
        end
    end

    def delete(conn, %{"id" => id, "user_id" => user_id}) do
        animal = AnimalContext.get_animal!(id)
        if authenticate(conn, user_id) do
            case AnimalContext.delete_animal(animal) do
                {:ok, _animal} ->
                    conn
                    |> send_resp(200, "Animal deleted")
                _ ->
                    conn
                    |> send_resp(400, "Something went wrong.")
            end
        end
    end

    def authenticate(conn, user_id) do
        if (user_id != nil) do
            user = UserContext.get_user(user_id)
            IO.inspect user
            user_keys = KeyContext.load_keys(user)
            api_key = get_req_header(conn, "x-api-key")
            Logger.debug "Keys value: #{inspect(api_key)}"
            keys = Enum.map(user_keys.keys, fn x -> x.value end)
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