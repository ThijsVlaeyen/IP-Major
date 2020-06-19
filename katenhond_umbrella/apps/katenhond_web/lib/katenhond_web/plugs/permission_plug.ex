defmodule KatenhondWeb.Plugs.PermissionPlug do
    import Plug.Conn
    alias Katenhond.KeyContext
    alias Katenhond.KeyContext.Key
    alias Katenhond.UserContext.User
    alias Phoenix.Controller
  
    def init(options), do: options
  
    def call(conn, options) do
      api_key = get_req_header(conn, "x-api-key")
      keys = KeyContext.list_keys()
      key = false

      key = for x <- keys do
        key = if String.equivalent?(x.value, api_key) do
          x.permission
        else
          key
        end
      end

      conn
      |> grant_access(key in options)
      
    end
  
    def grant_access(conn, true), do: conn
  
    def grant_access(conn, false) do
      conn
      |> Controller.redirect(to: "/noaccess")
      |> halt
    end
  end