defmodule SetGame.Game do
  alias SetGame.Deck
  alias SetGame.Card
  alias SetGame.Hand
  alias SetGame.Table

  defstruct deck: Deck.new,
    table: Table.new,
    hand: Hand.new,
    is_set: false,
    any_sets: false,
    id: nil

  @table_size 12

  def new(deck \\ Deck.new) do
    %SetGame.Game{ deck: Deck.shuffle(deck), id: random_id(10) }
  end

  def start(%{ table: table, deck: deck } = game) do
    {:ok, new_deck, new_table} = deck |> Deck.deal_up_to(table, @table_size)

    %SetGame.Game{ game |
      table: new_table,
      deck: new_deck,
      any_sets: Table.any_sets?(new_table),
    }
  end

  def pick_card(%{ hand: hand } = game, card) do
    new_hand = hand |> Hand.pick(card)
    %SetGame.Game{ game | hand: new_hand }
  end

  def full_hand?(%{ hand: hand }) do
    Hand.full?(hand)
  end

  def game_over?(%{ any_sets: true }), do: false
  def game_over?(%{ any_sets: false, deck: [] }), do: true
  def game_over?(_game), do: false

  def guess(%{ hand: hand } = game) do
    cond do
      Hand.is_set?(hand) -> %SetGame.Game{ game | is_set: true }
      true -> %SetGame.Game{ game | is_set: false }
    end
  end

  def reset_hand(game) do
    %SetGame.Game{ game | is_set: false, hand: Hand.new }
  end

  def replace_guessed_cards(game) do
    guessed_cards = MapSet.to_list(game.hand)
    {new_table, new_deck} = Table.replace_cards(game.table, guessed_cards, game.deck)
    %SetGame.Game{ game |
      table: new_table,
      deck: new_deck,
      hand: Hand.new,
      is_set: false,
      any_sets: Table.any_sets?(new_table),
    }
  end

  def deal_three_more(%{ deck: deck, table: table } = game) do
    {:ok, new_deck, new_table} = Deck.deal(deck, table, 3)

    %{ game |
      deck: new_deck,
      table: new_table,
      any_sets: Table.any_sets?(new_table),
    }
  end

  defp random_id(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
