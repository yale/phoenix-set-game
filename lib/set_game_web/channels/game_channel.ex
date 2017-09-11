defmodule SetGameWeb.GameChannel do
  use Phoenix.Channel

  intercept ["game:updated"]

  def join("game:" <> game_id, _params, socket) do
    socket = assign(socket, :game_id, game_id)

    {:ok, server} = SetGame.GameServer.whereis(game_id)
    state = SetGame.GameServer.state(server)
    json = SetGameWeb.GameView.render("show.json", state)

    {:ok, json, socket}
  end

  def handle_in("game:pick_card:" <> card_id, _params, socket) do
    {:ok, server} = SetGame.GameServer.whereis(socket.assigns.game_id)
    SetGame.GameServer.pick_card(server, card_id)
    {:noreply, socket}
  end

  def handle_in("game:guess_no_set", _params, socket) do
    {:ok, server} = SetGame.GameServer.whereis(socket.assigns.game_id)
    SetGame.GameServer.guess_no_set(server)
    {:noreply, socket}
  end

  def handle_out("game:updated", game, socket) do
    json = SetGameWeb.GameView.render("show.json", game)
    push socket, "game:updated", json
    {:noreply, socket}
  end
end
