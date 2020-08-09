defmodule KatenhondWeb.Plugs.PermissionPlug do
    import Plug.Conn
    alias Katenhond.KeyContext
    alias Katenhond.KeyContext.Key
    alias Katenhond.UserContext.User
    alias Phoenix.Controller
  
    def init(options), do: options
  
    def call(conn, permission) do
      api_key = get_req_header(conn, "x-api-key")
      
      key = KeyContext.get_by_api(api_key)

      conn
      |> grant_access(key != nil && key.permission in permission)
    end
  
    def grant_access(conn, true), do: conn
  
    def grant_access(conn, false) do
      conn
      |> Controller.redirect(to: "/noaccess")
      |> halt
    end
  end