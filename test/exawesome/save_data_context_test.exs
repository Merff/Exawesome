defmodule Exawesome.SaveDataContextTest do
  use Exawesome.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Exawesome.{Category, Lib, Repo, SaveDataContext}

  setup_all do
    HTTPoison.start
  end

  describe "upsert/1" do
    @params %{
      category_desc: "Libraries and tools for working with actors and such.",
      category_title: "Actors",
      libs: [
        %{
          href: "https://github.com/devinus/poolboy",
          lib_desc: " - A hunky Erlang worker pool factory.",
          lib_title: "poolboy"
        }
      ]
    }

    test "save new category/libs" do
      use_cassette "github_api_lib_data" do
        SaveDataContext.upsert([@params])

        [category] = Repo.all(Category)
        [lib] = Repo.all(Lib)
        [lib_params] = @params[:libs]

        assert category.name == @params[:category_title]
        assert category.description == @params[:category_desc]

        assert lib.category_id == category.id
        assert lib.href == lib_params[:href]
        assert lib.description == lib_params[:lib_desc]
        assert lib.name == lib_params[:lib_title]
        assert lib.stars == 1312
        assert lib.last_commit == ~U[2020-06-18 23:07:41Z]
      end
    end

    test "update category/lib" do
      use_cassette "github_api_lib_data" do
        [lib_params] = @params[:libs]

        {:ok, category} =
          %Category{
            name: @params[:category_title],
            description: @params[:category_desc],
            libs: [
              %{
                name: lib_params[:lib_title],
                description: lib_params[:lib_desc],
                href: lib_params[:href]
              }
            ]
          }
          |> Repo.insert()

        updated_lib_params = %{lib_params | lib_desc: "Updated lib description"}
        updated_params = %{@params | category_desc: "Updated category description", libs: [updated_lib_params]}

        SaveDataContext.upsert([updated_params])
        [category] = Repo.all(Category) |> Repo.preload(:libs)
        [lib] = category.libs

        assert category.description == "Updated category description"
        assert lib.description == "Updated lib description"
      end
    end

    test "do not save invalid data" do
      updated_params = %{@params | category_title: nil}
      SaveDataContext.upsert([updated_params])

      assert Repo.all(Category) == []
    end
  end
end
