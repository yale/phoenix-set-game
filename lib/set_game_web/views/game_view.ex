defmodule SetGameWeb.GameView do
  use SetGameWeb, :view

  def render("show.json", game) do
    table = game.table
            |> Enum.map(fn (card) ->
              Map.put(card, :selected, SetGame.Hand.has?(game.hand, card))
            end)
    %{
      hand: game.hand,
      table: table,
      is_set: game.is_set,
      any_sets: game.any_sets,
      game_over: SetGame.Game.game_over?(game),
    }
  end

  def card_classname(card) do
    ["card", card.color, to_word(card.number), card.shading, card.shape]
    |> Enum.join(" ")
  end

  defp to_word(number) when is_integer(number) do
    case number do
      1 -> "one"
      2 -> "two"
      3 -> "three"
      _ -> ""
    end
  end
end
