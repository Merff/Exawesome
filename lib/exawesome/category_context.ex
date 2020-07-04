defmodule Exawesome.CategoryContext do
  import Ecto.Query, only: [from: 2, dynamic: 2]
  alias Exawesome.{Category, Repo}

  def load_categories_with_libs(min_stars) do
    conditions = []

    conditions = if min_stars do
      dynamic([c, l], l.stars >= ^min_stars)
    else
      conditions
    end

    from(
      c in Category,
      join: l in assoc(c, :libs),
      order_by: c.name,
      order_by: l.name,
      where: ^conditions,
      preload: [libs: l]
    )
    |> Repo.all()
  end

end
