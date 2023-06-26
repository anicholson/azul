defmodule Azul.Models.Bag do
  @moduledoc """
  Represents the bag of tiles that factories are refilled from.
  Starts out with 100 tiles, 20 of each color.
  """

  @typedoc """
  Represents the bag of tiles that factories are refilled from.
  """
  @type t :: %__MODULE__{
          tiles: Azul.Models.TileCollection.t()
        }
  defstruct tiles: Azul.Models.TileCollection.full()
end
