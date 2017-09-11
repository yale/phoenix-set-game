defmodule SetGameWeb.ErrorController do
  use SetGameWeb, :controller

  def not_found(conn, _assigns) do
    render(conn, "404.html")
  end
end
