defmodule SetGame.Hand do
  alias SetGame.Card

  def new(cards \\ []) do
    MapSet.new(cards)
  end

  def has?(hand, card), do: MapSet.member?(hand, card)

  def pick(hand, card) do
    cond do
      # Remove card from the hand if it's already in it
      has?(hand, card) -> MapSet.delete(hand, card)
      # Add the card to the hand if there are fewer than 3 cards in it already
      MapSet.size(hand) < 3 -> MapSet.put(hand, card)
      # Otherwise, return the hand as is
      true -> hand
    end
  end

  def size(hand) do
    MapSet.size(hand)
  end

  def full?(hand) do
    size(hand) == 3
  end

  @doc """
  Checks if a given hand forms a set.

  A hand forms a set if:

  1. There are three cards in the hand
  2. For each property, all cards are either the same or different in that property
  """
  def is_set?(hand) do
    is_set?(hand, size(hand))
  end

  def is_set?(hand, size) when size == 3 do
    hand
    |> SetGame.Hand.set_violations
    |> Enum.empty?
  end
  def is_set?(_hand, _size), do: false

  def set_violations(hand) do
    properties = Card.properties |> Enum.map(fn(property) ->
      hand |> Enum.map(fn(card) -> Map.get(card, property) end)
    end)

    violating_propteries = Enum.reject(properties, fn(property) ->
      len = property |> Enum.uniq |> length
      len == 1 || len == 3
    end)

    violating_propteries
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(fn (property) -> Enum.chunk_by(property, &(&1)) end)
  end

  def set_violations_description(_violations) do
  end
end
