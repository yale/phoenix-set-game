defmodule SetGameWeb.AdminView do
  use SetGameWeb, :view

  def game_over(game), do: SetGame.Game.game_over?(game)
end
