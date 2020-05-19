defmodule Katenhond.AnimalContext do
  @moduledoc """
  The AnimalContext context.
  """

  import Ecto.Query, warn: false
  alias Katenhond.Repo

  alias Katenhond.AnimalContext.Animal
  alias Katenhond.UserContext.User

  defdelegate get_acceptable_animals(), to: Animal
  def load_animals(%User{} = u), do: u |> Repo.preload([:animals])

  @doc """
  Returns the list of animals.

  ## Examples

      iex> list_animals()
      [%Animal{}, ...]

  """
  def list_animals do
    Repo.all(Animal)
  end

  @doc """
  Gets a single animal.

  Raises `Ecto.NoResultsError` if the Animal does not exist.

  ## Examples

      iex> get_animal!(123)
      %Animal{}

      iex> get_animal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_animal!(id), do: Repo.get!(Animal, id) |> Repo.preload([:user])

  @doc """
  Creates a animal.

  ## Examples

      iex> create_animal(%{field: value})
      {:ok, %Animal{}}

      iex> create_animal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_animal(attrs, %User{} = user) do
    %Animal{}
    |> Animal.changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a animal.

  ## Examples

      iex> update_animal(animal, %{field: new_value})
      {:ok, %Animal{}}

      iex> update_animal(animal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_animal(%Animal{} = animal, attrs) do
    animal
    |> Animal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a animal.

  ## Examples

      iex> delete_animal(animal)
      {:ok, %Animal{}}

      iex> delete_animal(animal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_animal(%Animal{} = animal) do
    Repo.delete(animal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking animal changes.

  ## Examples

      iex> change_animal(animal)
      %Ecto.Changeset{source: %Animal{}}

  """
  def change_animal(%Animal{} = animal, %User{} = user) do
    Animal.changeset(animal, %{}, user)
  end


end
