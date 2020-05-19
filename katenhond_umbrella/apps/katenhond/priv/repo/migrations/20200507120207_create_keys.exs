defmodule Katenhond.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :name, :string, null: false
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:keys, [:user_id])
  end
end
