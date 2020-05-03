defmodule Katenhond.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Katenhond.AnimalContext.Animal

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    has_many :animals, Animal
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> unique_constraint(:username, name: :unique_users_index, message: "Username already taken")
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do  
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
