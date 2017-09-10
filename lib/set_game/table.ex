defmodule SetGame.Table do
  def new do
    []
  end

  def replace_cards(table, [], deck), do: {table, deck}

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
