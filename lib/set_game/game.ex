defmodule SetGame.Game do
  alias SetGame.Deck
  alias SetGame.Card
  alias SetGame.Hand
  alias SetGame.Table

  defstruct deck: Deck.new, table: Table.new, hand: Hand.new, is_set: false

  @table_size 12

  def new do
    %SetGame.Game{ deck: Deck.new |> Deck.shuffle }
  end

  def start(%SetGame.Game{ table: table, deck: deck } = game) do
    {:ok, new_deck, new_table} = deck |> Deck.deal_up_to(table, @table_size)
    %SetGame.Game{ game | table: new_table, deck: new_deck }
  end

  def pick_card(%SetGame.Game{ hand: hand } = game, %Card{} = card) do
    new_hand = hand |> SetGame.Hand.pick(card)
    %SetGame.Game{ game | hand: new_hand }
  end

  def guess(%SetGame.Game{ hand: hand } = game) do
    cond do
      Hand.is_set?(hand) -> %SetGame.Game{ game | is_set: true }
      true -> game
    end
  end

  def replace_guessed_cards(%SetGame.Game{} = game) do
    guessed_cards = MapSet.to_list(game.hand)
    {new_table, new_deck} = Table.replace_cards(game.table, guessed_cards, game.deck)
    %SetGame.Game{ game | table: new_table, deck: new_deck, hand: Hand.new }
  end
end
