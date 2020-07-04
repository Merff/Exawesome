defmodule Exawesome.GithubApi do
  require Logger

  @base_path "https://api.github.com/repos"

  def get_repo_info(repo_owner, repo_name) do
    url = "#{@base_path}/#{repo_owner}/#{repo_name}"
    credentials =
      Application.get_env(:exawesome, :github_user)
      <> ":"
      <> Application.get_env(:exawesome, :github_token)
      |> Base.encode64()
    headers = [
      {"Authorization", "Basic #{credentials}"},
      {"X-GitHub-Media-Type", "application/vnd.github.scarlet-witch-preview+json"}
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        resp = Jason.decode!(body)

        %{
          stars: resp["stargazers_count"],
          last_commit: resp["pushed_at"]
        }
      _ ->
        Logger.warn("#{url} not available")
        :error
    end
  end
end
