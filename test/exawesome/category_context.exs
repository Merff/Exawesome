defmodule Exawesome.CategoryContextTest do
  use Exawesome.DataCase
  alias Exawesome.{Repo, Category, CategoryContext}

  setup do
    {:ok, _record} =
      %Category{
        description: "Libraries and tools for working with actors and such.",
        name: "Actors",
        libs: [
          %{
            href: "https://github.com/devinus/poolboy",
            description: " - A hunky Erlang worker pool factory.",
            name: "poolboy",
            stars: 1250
          }
        ]
      }
      |> Repo.insert()

    :ok
  end

  describe "load_categories_with_libs/1" do
    test "without min_stars params" do
      [category] = CategoryContext.load_categories_with_libs(nil)
      [lib] = category.libs

      assert category.name == "Actors"
      assert lib.name == "poolboy"
    end

    test "with 500 min_stars params" do
      [category] = CategoryContext.load_categories_with_libs(500)
      [lib] = category.libs

      assert category.name == "Actors"
      assert lib.name == "poolboy"
    end

    test "with 2000 min_stars params" do
      assert CategoryContext.load_categories_with_libs(2000) == []
    end
  end
end
