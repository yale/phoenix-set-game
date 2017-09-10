defmodule SetGameWeb.PageController do
  use SetGameWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def game(conn, _params) do
    game = SetGame.Game.new |> SetGame.Game.start

    conn
    |> assign(:game, game)
    |> render "game.html"
  end
end
