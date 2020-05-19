defmodule Katenhond.KeyContext do
  @moduledoc """
  The KeyContext context.
  """

  import Ecto.Query, warn: false
  alias Katenhond.Repo

  alias Katenhond.KeyContext.Key
  alias Katenhond.UserContext.User

  def load_keys(%User{} = u) do
     u |> Repo.preload([:keys])
  end

  @doc """
  Returns the list of keys.

  ## Examples

      iex> list_keys()
      [%Key{}, ...]

  """
  def list_keys do
    Repo.all(Key)
  end

  @doc """
  Gets a single key.

  Raises `Ecto.NoResultsError` if the Key does not exist.

  ## Examples

      iex> get_key!(123)
      %Key{}

      iex> get_key!(456)
      ** (Ecto.NoResultsError)

  """
  def get_key!(id) do
    Repo.get!(Key, id) |> Repo.preload([:user])
  end

  @doc """
  Creates a key.

  ## Examples

      iex> create_key(%{field: value})
      {:ok, %Key{}}

      iex> create_key(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_key(name, %User{} = user) do
    value = generate_random_value()
    attributes = %{name: name, value: value}
    %Key{}
    |> Key.create_changeset(attributes,user)
    |> Repo.insert()
  end

  # Generate random value
  defp generate_random_value(length) do
    :crypto.strong_rand_bytes(length) 
    |> Base.encode64 
    |> binary_part(0, length)
  end

  defp generate_random_value() do
    generate_random_value(32)
  end

  @doc """
  Updates a key.

  ## Examples

      iex> update_key(key, %{field: new_value})
      {:ok, %Key{}}

      iex> update_key(key, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_key(%Key{} = key, attrs) do
    key
    |> Key.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a key.

  ## Examples

      iex> delete_key(key)
      {:ok, %Key{}}

      iex> delete_key(key)
      {:error, %Ecto.Changeset{}}

  """
  def delete_key(%Key{} = key) do
    Repo.delete(key)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking key changes.

  ## Examples

      iex> change_key(key)
      %Ecto.Changeset{source: %Key{}}

  """
  def change_key(%Key{} = key) do
    Key.changeset(key, %{})
  end
end
