defmodule SetGame.Table do
  def new do
    []
  end

  def any_sets?(table) do
    combos = for a <- table,
      b <- table,
      c <- table,
      a != b,
      b != c,
      a != c, do: SetGame.Hand.new([a, b, c])

    combos |> Enum.any?(&SetGame.Hand.is_set?/1)
  end

  def replace_cards(table, [], deck) do
    {Enum.reject(table, &is_nil/1), deck}
  end

  @doc """
  When there are extra cards on the table, use the last cards
  as the deck
  """
  def replace_cards(table, cards_to_replace, deck) when length(table) > 12 do
    {new_table, top} = Enum.split(table, length(table) - 3)

    # Only replace cards not in the new top of the deck
    new_cards_to_replace = Enum.reduce(
      top,
      cards_to_replace,
      fn (card, to_replace) -> List.delete(to_replace, card) end
    )

    # Only add to the top of the deck cards that don't need to be replaced
    new_top = Enum.reduce(
      cards_to_replace,
      top,
      fn (card, from_top) -> List.delete(from_top, card) end
    )

    new_deck = new_top ++ deck

    replace_cards(new_table, new_cards_to_replace, new_deck)
  end

  def replace_cards(table, [card | rest], deck) do
    {new_card, new_deck} = case SetGame.Deck.draw(deck) do
      {:ok, new_card, new_deck} -> {new_card, new_deck}
      {:error, :empty_deck} -> {nil, []}
    end

    table
    |> replace_card(card, new_card)
    |> replace_cards(rest, new_deck)
  end

  def replace_card(table, card_to_replace, new_card) do
    index = find_card_index(table, card_to_replace)
    replace_card_at_index(table, index, new_card)
  end

  def replace_card_at_index(table, index, new_card) do
    table
    |> List.replace_at(index, new_card)
  end

  defp find_card_index(table, card) do
    Enum.find_index(table, fn(c) -> c == card end)
  end
end
