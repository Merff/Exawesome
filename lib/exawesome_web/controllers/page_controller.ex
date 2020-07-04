defmodule ExawesomeWeb.PageController do
  use ExawesomeWeb, :controller

  def index(conn, params) do
    categories = Exawesome.CategoryContext.load_categories_with_libs(params["min_stars"])
    utc_now = DateTime.utc_now()

    render(conn, "index.html", categories: categories, utc_now: utc_now)
  end
end
