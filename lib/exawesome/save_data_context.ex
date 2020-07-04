defmodule Exawesome.SaveDataContext do

  alias Exawesome.{Repo, GithubApi, Category, Lib}

  def upsert(params) do
    #require IEx; IEx.pry()
    Enum.each(params, fn category ->
      category =
        %{
          name: category[:category_title],
          description: category[:category_desc]
        }
        |> upsert_category()

      Enum.each(category[:libs], fn lib ->
        [_, _, repo_owner, repo_name | _] = Path.split(lib[:href])

        lib_params = %{
          name: lib[:lib_title],
          description: lib[:lib_desc],
          href: lib[:href],
          category_id: category[:id]
        }

        lib_params =
          case GithubApi.get_repo_info(repo_owner, repo_name) do
            %{stars: stars, last_commit: last_commit} ->
              lib_params
              |> Map.put(:stars, stars)
              |> Map.put(:last_commit, last_commit)
            :error ->
              lib_params
          end

        upsert_lib(lib_params)
      end)
    end)
  end

  def upsert_category(params) do
    Repo.get_by(Category, name: params.name)
    |> case do
      nil ->
        %Category{}
        |> Category.changeset(params)
        |> Repo.insert()
      category ->
        category
        |> Ecto.Changeset.change(params)
        |> Repo.update()
    end
  end

  def upsert_lib(params) do
    Repo.get_by(Lib, href: params.href)
    |> case do
      nil ->
        %Lib{}
        |> Lib.changeset(params)
        |> Repo.insert()
      lib ->
        lib
        |> Ecto.Changeset.change(params)
        |> Repo.update()
    end

  end

end
