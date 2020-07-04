# Exawesome

Deployed version here:

To start project locally:

  * Clone repo from https://github.com/Merff/Exawesome
  * Fill db and github-api credentials in config.exs/dev.exs files
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `ies -S mix phx.server`
  * Fetch real data by run in iex console `Exawesome.GithubProducer.produce()`
  * Wait 😴

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO

  * Removes libs which removed from https://github.com/h4cc/awesome-elixir
  * Make SaveDataContext async
