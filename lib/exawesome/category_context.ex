defmodule Exawesome.CategoryContext do
  import Ecto.Query, only: [from: 2]
  alias Exawesome.{Category, Lib, Repo}

  def load_categories_with_libs() do
    libs_query = from(l in Lib, order_by: l.name)

    from(p in Category, order_by: p.name, preload: [libs: ^libs_query])
    |> Repo.all()
  end

end
