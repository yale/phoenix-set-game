defmodule SetGame.Hand do
  alias SetGame.Card

  def new do
    %MapSet{}
  end

  def pick(hand, card) do
    cond do
      # Remove card from the hand if it's already in it
      MapSet.member?(hand, card) -> MapSet.delete(hand, card)
      # Add the card to the hand if there are fewer than 3 cards in it already
      MapSet.size(hand) < 3 -> MapSet.put(hand, card)
      # Otherwise, return the hand as is
      true -> hand
    end
  end

  @doc """
  Checks if a given hand forms a set.

  A hand forms a set if:

  1. There are three cards in the hand
  2. For each property, all cards are either the same or different in that property
  """
  def is_set?(hand) do
    Card.properties
    |> Enum.all?(fn(property) ->
      uniq_properties = hand
      |> Enum.map(fn(card) -> Map.get(card, property) end)
      |> Enum.uniq

      length(uniq_properties) == 1 || length(uniq_properties) == 3
    end)
  end
end
