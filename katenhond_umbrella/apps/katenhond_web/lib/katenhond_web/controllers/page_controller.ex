defmodule KatenhondWeb.PageController do
  use KatenhondWeb, :controller

  alias Katenhond.AnimalContext

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "users")
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end

  def home(conn, _param) do
    animals = AnimalContext.list_animals()
    render(conn, "home.html", animals: animals)
  end
end
