defmodule SetGame.Card do
  @properties [:color, :number, :shape, :shading]
  @colors [:red, :green, :purple]
  @numbers [1, 2, 3]
  @shapes [:squiggle, :diamond, :pill]
  @shadings [:solid, :shaded, :empty]

  defstruct @properties ++ [:id]

  def properties, do: @properties
  def colors, do: @colors
  def numbers, do: @numbers
  def shapes, do: @shapes
  def shadings, do: @shadings

  def new(%{ color: color, number: number, shading: shading, shape: shape }) do
    card = %SetGame.Card{
      color: color,
      number: number,
      shading: shading,
      shape: shape
    }

    id = SetGame.Card.gen_id(card)

    %SetGame.Card{ card | id: id }
  end

  @doc """
  Generates an integer ID that encodes information about the card.
  """
  def gen_id(%SetGame.Card{
    color: color,
    number: number,
    shape: shape,
    shading: shading,
  }) do
    with color_index <- Enum.find_index(@colors, &(&1 == color)),
         number_index <- Enum.find_index(@numbers, &(&1 == number)),
         shape_index <- Enum.find_index(@shapes, &(&1 == shape)),
         shading_index <- Enum.find_index(@shadings, &(&1 == shading)) do
      27 * color_index + 9 * number_index + 3 * shape_index + shading_index
    end
  end
end
