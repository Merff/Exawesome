defmodule Exawesome.GithubProducerTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "produce()" do
    use_cassette "github_markdown" do
      [example | _result] = Exawesome.GithubProducer.produce

      assert example == %{
        category_desc: "Useful Elixir-related websites.",
        category_title: "Websites",
        libs: [
          %{
            href: "https://github.com/seven1m/30-days-of-elixir",
            lib_desc: " - A walk through the Elixir language in 30 exercises.",
            lib_title: "30 Days of Elixir"
          },
          %{
            href: "https://github.com/elixir-lang/elixir",
            lib_desc: " - The project repository.",
            lib_title: "Elixir Github Repository"
          },
          %{
            href: "https://github.com/elixir-lang/elixir/wiki",
            lib_desc: " - The project's wiki, containing much useful information.",
            lib_title: "Elixir Github Wiki"
          }
        ]
      }
    end
  end
end
