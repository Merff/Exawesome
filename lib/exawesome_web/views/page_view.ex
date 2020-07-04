defmodule ExawesomeWeb.PageView do
  use ExawesomeWeb, :view

  def days_left_from_last_commit(nil, datetime_now), do: nil
  def days_left_from_last_commit(datetime_commit, datetime_now) do
    DateTime.diff(datetime_now, datetime_commit)
    |> div(86_400)
  end
end
