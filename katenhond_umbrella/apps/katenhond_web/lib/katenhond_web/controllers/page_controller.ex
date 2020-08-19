defmodule KatenhondWeb.PageController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias Katenhond.UserContext

    def index(conn, _params) do
        render(conn, "index.html")
    end

    def noaccess(conn,_params) do
        render(conn,"noaccess.html")
    end

    def dashboard(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        user_with_loaded_animals = UserContext.load_animals(user)
        animals_of_loggedin_user = user_with_loaded_animals.animals
        render(conn, "home.html", animals: animals_of_loggedin_user)
    end

    def management(conn, _params) do
        redirect(conn, to: "/users")
    end

    def apikeys(conn, _params) do
        redirect(conn, to: "/admin/apikeys/overview")
    end

end