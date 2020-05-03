defmodule KatenhondWeb.ProfileController do
    use KatenhondWeb, :controller

    alias KatenhondWeb.Guardian
    alias KatenhondWeb.UserContext

    defp getUser(conn) do
        Guardian.Plug.current_resource(conn);
    end

    def profile(conn, _params) do
        user = getUser(conn);
        render(conn, "profile.html", user: user)
    end
    
end