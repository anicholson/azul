defmodule Azul.Models.Factory do
  @moduledoc """
  Responsible for holding the tiles in a factory.

  A factory may be empty, or may contain up to 4 tiles.

  Players may choose to take all tiles of a single color from a factory, and
  place them on their pattern lines. The remaining tiles will be placed in the
  center of the marketplace.
  """

  @typedoc "Represents a factory."
  @type t :: %__MODULE__{
          tiles: Azul.TileCollection.t()
        }
  defstruct tiles: Azul.Models.TileCollection.empty()

  @spec new :: Azul.Models.Factory.t()
  def new() do
    %Azul.Models.Factory{}
  end

  @spec empty?(t()) :: boolean()
  def empty?(factory) do
    factory.tiles == Azul.Models.TileCollection.empty()
  end
end
