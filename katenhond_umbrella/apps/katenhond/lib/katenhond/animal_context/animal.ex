defmodule Katenhond.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Katenhond.UserContext.User

  schema "animals" do
    field :born, :date
    field :name, :string
    field :cat_or_dog, :string
    belongs_to :user, User

  end

  @doc false
  def changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:name, :cat_or_dog, :born])
    |> validate_required([:name, :cat_or_dog, :born])
    |> put_assoc(:user, user)
  end
end
