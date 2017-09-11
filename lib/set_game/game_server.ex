defmodule SetGame.GameServer do
  use GenServer
  alias SetGame.Game

  def start(pid), do: GenServer.call(pid, :start)

  def pick_card(pid, card_id) when is_binary(card_id) do
    pick_card(pid, String.to_integer(card_id))
  end
  def pick_card(pid, card_id), do: GenServer.call(pid, {:pick_card, card_id})

  def guess_no_set(pid), do: GenServer.call(pid, {:guess_no_set})

  def state(pid), do: GenServer.call(pid, :state)

  def whereis(id) do
    case Registry.lookup(:registry, {:game_server, id}) do
      [{game_server, _}] -> {:ok, game_server}
      _ -> {:notfound, nil}
    end
  end

  def start_link(initial_game \\ Game.new) do
    GenServer.start_link(__MODULE__, initial_game, name: via_tuple(initial_game.id))
  end

  def init(game) do
    IO.puts("Starting GameServer #{game.id}")
    {:ok, game}
  end

  def handle_call(:start, _from, game) do
    new_game = Game.start(game)
    {:reply, new_game, new_game}
  end

  def handle_call(:state, _from, game) do
    {:reply, game, game}
  end

  # NOTE: This seems like a lot of game logic baked into the server
  def handle_call({:pick_card, card_id}, _from, game) do
    card = Enum.find(game.table, fn(c) -> c.id == card_id end)
    game = Game.pick_card(game, card) |> broadcast
    game = Game.guess(game) |> broadcast

    game = cond do
      game.is_set -> Game.replace_guessed_cards(game)
      Game.full_hand?(game) -> Game.reset_hand(game)
      true -> game
    end

    broadcast(game)

    {:reply, game, game}
  end

  def handle_call({:guess_no_set}, _from, game) do
    unless game.any_sets do
      game = game |> Game.deal_three_more |> broadcast
    end

    {:reply, game, game}
  end

  defp via_tuple(id) do
    {:via, Registry, {:registry, {:game_server, id}}}
  end

  defp broadcast(game) do
    SetGameWeb.Endpoint.broadcast("game:#{game.id}", "game:updated", game)
    game
  end
end
