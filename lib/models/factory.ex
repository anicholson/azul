defmodule Azul.Models.Factory do
  @moduledoc """
  Responsible for holding the tiles in a factory.

  A factory may be empty, or may contain up to 4 tiles.

  Players may choose to take all tiles of a single color from a factory, and
  place them on their pattern lines. The remaining tiles will be placed in the
  center of the marketplace.
  """

  alias Azul.Models.{Tile, TileCollection}

  @typedoc "Represents a factory."
  @type t :: %__MODULE__{
          tiles: TileCollection.t()
        }
  defstruct tiles: TileCollection.empty()

  @spec new :: Azul.Models.Factory.t()
  def new() do
    %Azul.Models.Factory{}
  end

  @doc """
  Returns `true` if the factory is has no `tiles`, `false` otherwise.

  Examples:

    iex> Azul.Models.Factory.empty?(Azul.Models.Factory.new())
    true
    iex> tc = %{ blue: 1, yellow: 1, red: 0, white: 2, black: 0}
    iex> Azul.Models.Factory.empty?(%Azul.Models.Factory{tiles: tc})
    false
  """
  @spec empty?(t()) :: boolean()
  def empty?(factory) do
    factory.tiles == TileCollection.empty()
  end

  @doc """
  Takes all tiles of a single color from a factory.

  Returns a tuple with the following values:
  {:ok, taken_tiles, leftover_tiles, new_factory}

  where:

  * `taken_tiles` is a map of the tiles taken from the factory
  * `leftover_tiles` is a map of the tiles that were not taken
  * `new_factory` is a new, empty factory
  """
  @spec take(t(), Tile.t()) :: {:ok, {Tile.t(), 1..4}, TileCollection.t(), t()} | Azul.error()
  def take(factory, color) do
    cond do
      empty?(factory) ->
        {:error, "Cannot take tiles from an empty factory"}

      Map.fetch!(factory.tiles, color) == 0 ->
        {:error, "Factory has no #{color} tiles to take"}

      true ->
        {taken_tiles, leftover_tiles} = split(factory.tiles, color)
        {:ok, taken_tiles, leftover_tiles, new()}
    end
  end

  defp split(tc, color) do
    {taken_tiles, leftover_tiles} = Map.split(tc, [color])
    [taken_tiles] = Map.to_list(taken_tiles)
    leftover_tiles = Map.merge(TileCollection.empty(), leftover_tiles)
    {taken_tiles, leftover_tiles}
  end
end
