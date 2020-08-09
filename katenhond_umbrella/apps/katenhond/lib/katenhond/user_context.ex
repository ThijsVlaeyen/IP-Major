defmodule Katenhond.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Katenhond.Repo

  alias Katenhond.UserContext.User

  defdelegate get_acceptable_roles(), to: User

  # Load Animals for a specific user
  def load_animals(%User{} = u), do: u |> Repo.preload([:animals])

  # Load Keys for a specific user
  def load_keys(%User{} = u), do: u |> Repo.preload([:keys])

  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

    # Change username
  def change_username(user,newusername) do
    updated = Ecto.Changeset.change(user,username: newusername)
    Repo.update(updated)
  end

  # Change password
  def change_password(user, old_password, new_password, confirmpassword) do
  IO.inspect new_password
  IO.inspect confirmpassword
    if new_password == confirmpassword do
      if Pbkdf2.verify_pass(old_password,user.hashed_password) do
        updated = Ecto.Changeset.change(user,hashed_password: Pbkdf2.hash_pwd_salt(new_password))
        Repo.update(updated)
      else
        {:error, :invalid_credentials}
      end
    else
      {:error, :non_matching}
    end
    
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(username, password, confirmpassword, role) do
    if password == confirmpassword do
      %User{}
      |> User.changeset(%{"username" => username, "password" => password, "role" => role})
      |> Repo.insert()
    else
      {:error, :passwords_do_not_match}
    end
  end

  def create_seed(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of users.  

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get(User, id)
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
