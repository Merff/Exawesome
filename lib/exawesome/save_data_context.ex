defmodule Exawesome.SaveDataContext do

  alias Exawesome.{Repo, GithubApi, Category, Lib}

  def upsert(params) do
    Enum.each(params, fn category_params ->
      %{
        name: category_params[:category_title],
        description: category_params[:category_desc]
      }
      |> upsert_category()
      |> case do
        {:ok, category_record} ->
          Enum.each(category_params[:libs], fn lib ->
            lib_params = %{
              name: lib[:lib_title],
              description: lib[:lib_desc],
              href: lib[:href],
              category_id: category_record.id
            }

            extend_lib_params_by_github_api(lib_params)
            |> upsert_lib()
          end)
        _ -> :error
      end
    end)
  end

  defp extend_lib_params_by_github_api(lib_params) do
    [_, _, repo_owner, repo_name | _] = Path.split(lib_params[:href])

    case GithubApi.get_repo_info(repo_owner, repo_name) do
      %{stars: stars, last_commit: last_commit} ->
        {:ok, last_commit, _} = DateTime.from_iso8601(last_commit)

        lib_params
        |> Map.put(:stars, stars)
        |> Map.put(:last_commit, last_commit)
      :error ->
        lib_params
    end
  end

  defp upsert_category(%{name: nil}), do: :error
  defp upsert_category(params) do
    Repo.get_by(Category, name: params[:name])
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

  defp upsert_lib(%{href: nil}), do: :error
  defp upsert_lib(params) do
    Repo.get_by(Lib, href: params[:href])
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
