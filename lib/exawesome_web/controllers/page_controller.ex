defmodule ExawesomeWeb.PageController do
  use ExawesomeWeb, :controller

  def index(conn, _params) do
    categories = Exawesome.CategoryContext.load_categories_with_libs()
    render(conn, "index.html", categories: categories)
  end
end
