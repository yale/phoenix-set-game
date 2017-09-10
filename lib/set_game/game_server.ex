defmodule SetGame.GameServer do
  use GenServer
  alias SetGame.Game

  def start(pid), do: GenServer.call(pid, :start)
  def pick_card(pid, card_id), do: GenServer.call(pid, {:pick_card, card_id})

  def start_link(initial_game \\ Game.new) do
    GenServer.start_link(__MODULE__, initial_game)
  end

  def init(game) do
    {:ok, game}
  end

  def handle_call(:start, _from, game) do
    new_game = Game.start(game)
    {:reply, new_game, new_game}
  end

  def handle_call({:pick_card, card_id}, _from, game) do
    card = Enum.find(game.table, fn(c) -> c.id == card_id end)
    {:reply, Game.pick_card(game, card)}
  end
end
