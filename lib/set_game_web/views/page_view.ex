defmodule SetGameWeb.PageView do
  use SetGameWeb, :view

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
