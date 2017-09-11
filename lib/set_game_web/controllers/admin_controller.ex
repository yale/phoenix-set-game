defmodule SetGameWeb.AdminController do
  use SetGameWeb, :controller

  def show(conn, %{"id" => id}) do
    case SetGame.GameServer.whereis(id) do
      {:notfound, nil} -> redirect(conn, to: "/error/404")
      {:ok, game_server} ->
        game = SetGame.GameServer.state(game_server)
        conn
        |> assign(:game, game)
        |> assign(:pid, inspect(game_server))
        |> render("show.html")
    end
  end
end
