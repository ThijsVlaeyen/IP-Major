defmodule Katenhond.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Katenhond.UserContext.User

  @acceptable_animals ["Cat", "Dog"]

  schema "animals" do
    field :born, :date
    field :name, :string
    field :cat_or_dog, :string
    belongs_to :user, User
  end

  def get_acceptable_animals, do: @acceptable_animals

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :cat_or_dog, :born])
    |> validate_required([:name, :cat_or_dog, :born])
  end

  @doc false
  def changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:name, :cat_or_dog, :born])
    |> validate_required([:name, :cat_or_dog, :born])
    |> validate_inclusion(:cat_or_dog, @acceptable_animals)
    |> put_assoc(:user, user)
  end
end
