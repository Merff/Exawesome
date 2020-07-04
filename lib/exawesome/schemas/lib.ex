defmodule Exawesome.Lib do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libs" do
    field :name, :string
    field :href, :string
    field :description, :string
    field :stars, :integer
    field :last_commit, :utc_datetime
    belongs_to :category, Exawesome.Category

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :href, :description, :stars, :last_commit, :category_id])
    |> validate_required([:name, :href, :category_id])
    |> unique_constraint(:href)
  end

end
