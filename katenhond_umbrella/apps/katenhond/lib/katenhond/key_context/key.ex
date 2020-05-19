defmodule Katenhond.KeyContext.Key do
  use Ecto.Schema
  import Ecto.Changeset

  alias Katenhond.UserContext.User

  schema "keys" do
    field :name, :string
    field :value, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end

  @doc false
  def create_changeset(key, attrs, user) do
    key
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
    |> put_assoc(:user, user)
  end
end
