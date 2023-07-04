defmodule Azul.Models.TileCollection do
  @typedoc """
  A collection of tiles. Keeps count of the number of `Azul.tile.t` in the collection.
  """
  @type t :: %{
          blue: non_neg_integer(),
          red: non_neg_integer(),
          yellow: non_neg_integer(),
          black: non_neg_integer(),
          white: non_neg_integer()
        }

  @doc """
  Creates a new empty tile collection.

  Examples:

  iex> Azul.Models.TileCollection.empty()
  %{
    black: 0,
    blue: 0,
    red: 0,
    white: 0,
    yellow: 0
  }
  """
  @spec empty() :: Azul.Models.TileCollection.t()
  def empty() do
    %{
      blue: 0,
      red: 0,
      yellow: 0,
      black: 0,
      white: 0
    }
  end

  @spec empty?(t()) :: boolean()
  def empty?(tile_collection) do
    tile_collection == empty()
  end

  @spec full() :: Azul.Models.TileCollection.t()
  def full() do
    %{
      blue: 20,
      red: 20,
      yellow: 20,
      black: 20,
      white: 20
    }
  end

  @spec from_list([Azul.Models.Tile.t()]) :: Azul.Models.TileCollection.t()
  def from_list(tiles) do
    Enum.reduce(tiles, empty(), fn tile, acc ->
      Map.update(acc, tile, 1, & &1 + 1)
    end)
  end
end
