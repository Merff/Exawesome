defmodule GithubProducer do

  @markdown_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def produce() do
    {:ok, ast, _} =
      get_readme_page(@markdown_url)
      |> Earmark.as_ast()

    parse_ast(ast, [])
  end

  defp parse_ast(ast, accum) do
    case ast do
      [ {"h2", _, [category_title]},
        {"p", [], [{"em", [], [category_desc]}]},
        {"ul", [], libs}
        | tail ] -> parse_ast(tail, [%{category_title: category_title, category_desc: category_desc, libs: parse_libs(libs)} | accum])
      [_ | tail] -> parse_ast(tail, accum)
      [] -> accum
    end
  end

  defp parse_libs(libs) do
    Enum.flat_map(libs,
      fn {"li", [], [{"a", [{"href", href}], [lib_title]}, lib_desc]} ->
        if String.contains?(href, "github.com") do
          [%{href: href, lib_title: lib_title, lib_desc: lib_desc}]
        else
          []
        end
      _ -> []
    end)
  end

  def get_readme_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      _ ->
        raise("#{url} not available")
    end
  end
end

