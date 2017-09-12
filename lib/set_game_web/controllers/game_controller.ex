defmodule SetGameWeb.GameController do
  use SetGameWeb, :controller

  def create(conn, %{"deck_size" => deck_size}) do
    SetGame.Deck.new
    |> SetGame.Deck.shuffle
    |> Enum.take(String.to_integer(deck_size))
    |> new_game_and_redirect(conn)
  end

  def create(conn, _assigns) do
    new_game_and_redirect(conn)
  end

  def show(conn, %{"id" => id}) do
    case SetGame.GameServer.whereis(id) do
      {:notfound, nil} -> redirect(conn, to: "/error/404")
      {:ok, game_server} ->
        game = SetGame.GameServer.state(game_server)
        conn
        |> assign(:game, game)
        |> render("show.html")
    end
  end

  def admin(conn, %{"id" => id}) do
    case SetGame.GameServer.whereis(id) do
      {:notfound, nil} -> redirect(conn, to: "/error/404")
      {:ok, game_server} ->
        game = SetGame.GameServer.state(game_server)
        conn
        |> assign(:game, game)
        |> render("admin.html")
    end
  end

  defp new_game_and_redirect(conn) do
    new_game_and_redirect(SetGame.Deck.new, conn)
  end

  defp new_game_and_redirect(deck, conn) do
    game = SetGame.Game.new(deck) |> SetGame.Game.start
    {:ok, _} = SetGame.ServerSupervisor.start_server(game)
    redirect conn, to: "/game/#{game.id}"
  end
end
