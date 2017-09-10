defmodule SetGame.Deck do
  alias SetGame.Card

  def new do
    for color <- Card.colors,
      number <- Card.numbers,
      shape <- Card.shapes,
      shading <- Card.shadings do
      Card.new(%{ color: color, number: number, shading: shading, shape: shape })
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Draw a single card

  Examples:

    iex> deck = [1, 2, 3, 4]
    iex> SetGame.Deck.draw(deck)
    {:ok, 1, [2, 3, 4]}

  Calling draw on an empty deck returns an error:

    iex> SetGame.Deck.draw([])
    {:error, :empty_deck}
  """
  def draw([]), do: {:error, :empty_deck}
  def draw([card | deck]), do: {:ok, card, deck}

  @doc """
  Deal a specific number of cards

  Examples:

    iex> deck = [1, 2, 3]
    iex> SetGame.Deck.deal(deck, [], 2)
    {:ok, [3], [1, 2]}
  """
  def deal(deck, hand, n) do
    {cards, new_deck} = deck |> Enum.split(n)
    new_hand = hand ++ cards
    {:ok, new_deck, new_hand}
  end

  @doc """
  Deal until a hand is a certain length

  Examples:

    iex> deck = [1, 2, 3, 4, 5]
    iex> hand = [0]
    iex> SetGame.Deck.deal_up_to(deck, hand, 4)
    {:ok, [4, 5], [0, 1, 2, 3]}

  Dealing into a full hand returns an error:

    iex> deck = [1, 2, 3, 4]
    iex> hand = [5, 6, 7, 8]
    iex> SetGame.Deck.deal_up_to(deck, hand, 4)
    {:error, :hand_full}
  """
  def deal_up_to(_deck, hand, n) when length(hand) >= n do
    {:error, :hand_full}
  end

  def deal_up_to(deck, hand, n) do
    deal(deck, hand, n - length(hand))
  end
end
