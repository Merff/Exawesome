defmodule Exawesome.Repo.Migrations.AddLibs do
  use Ecto.Migration

  def change do
    create table(:libs) do
      add :name, :string, null: false
      add :href, :string, null: false
      add :description, :text
      add :stars, :integer
      add :last_commit, :utc_datetime
      add :category_id, references("categories"), null: false

      timestamps()
    end

    create unique_index(:libs, [:href])
    create index(:libs, [:category_id])
  end
end
