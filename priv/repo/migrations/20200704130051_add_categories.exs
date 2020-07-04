defmodule Exawesome.Repo.Migrations.AddCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
