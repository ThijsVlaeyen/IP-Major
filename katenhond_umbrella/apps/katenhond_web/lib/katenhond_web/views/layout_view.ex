defmodule KatenhondWeb.LayoutView do
  use KatenhondWeb, :view

  alias KatenhondWeb.Guardian
  alias KatenhondWeb.Endpoint

  def isloggedin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user do
      true
    else
      false
    end
  end

  def isadmin(conn) do
    user = Guardian.Plug.current_resource(conn);
    if user.role == "Admin" do
      true
    else
      false
    end
  end
end
