defmodule SetGame.GameServer do
  use GenServer
  alias SetGame.Game
  @cleanup_after 10000

  # Interface functions

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

  # Implementation functions

  def init(game) do
    IO.puts("Starting GameServer #{game.id}")
    Process.send_after(self(), :cleanup, @cleanup_after)
    {:ok, game}
  end

  def handle_info(:cleanup, game) do
    cond do
      Game.game_over?(game) -> {:stop, :normal, game}
      Game.time_out?(game) -> {:stop, :normal, game}
      true ->
        Process.send_after(self(), :cleanup, @cleanup_after)
        {:noreply, game}
    end
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
    game = game |> Game.pick_card(card) |> Game.guess |> broadcast

    game = cond do
      game.is_set -> Game.replace_guessed_cards(game) |> broadcast
      Game.full_hand?(game) -> Game.reset_hand(game) |> broadcast
      true -> game
    end

    {:reply, game, game}
  end

  def handle_call({:guess_no_set}, _from, game) do
    game =
      case game.any_sets do
        true -> game |> Game.deal_three_more |> broadcast
        false -> game
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
