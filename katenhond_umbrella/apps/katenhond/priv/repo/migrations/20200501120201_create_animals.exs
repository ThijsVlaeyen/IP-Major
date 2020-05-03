defmodule Katenhond.Repo.Migrations.CreateAnimals do
  use Ecto.Migration

  def change do
    create table(:animals) do
      add :name, :string, null: false
      add :cat_or_dog, :string, null: false
      add :born, :date, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:animals, [:user_id])
  end
end
