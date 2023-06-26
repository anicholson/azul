defmodule Azul.Models.Marketplace do
  @moduledoc """
  Represents the middle of the table between the factories. This is where
  leftover tiles are placed after a player takes tiles from a factory.
  """

  @typedoc "Represents the marketplace."
  @type t :: %__MODULE__{
          tiles: Azul.Models.TileCollection.t(),
          penalty: Azul.Models.Tile.penalty() | nil
        }
  defstruct tiles: Azul.Models.TileCollection.empty(), penalty: :penalty

  @spec new :: Azul.Models.Marketplace.t()
  def new() do
    %Azul.Models.Marketplace{}
  end

  @spec penalty?(t()) :: boolean()
  def penalty?(marketplace) do
    marketplace.penalty != nil
  end
end
