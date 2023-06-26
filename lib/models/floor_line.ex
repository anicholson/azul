defmodule Azul.Models.FloorLine do
  @moduledoc """
  Represents a floor line on a player's board. Each space on a floor line
  accepts either a coloured `Azul.Models.Tile` or a `:penalty` tile.

  Each space has a corresponding penalty value that is applied to the player's
  score at the end of the round if the space is occupied.
  """

  @typedoc """
  Represents a space on a floor line.
  """
  @type space :: Azul.Models.Tile.t() | Azul.Models.Tile.penalty() | nil

  @type t :: %__MODULE__{
          spaces: [space()],
          penalty: non_neg_integer()
        }
  defstruct spaces: [], penalty: 0

  @doc """
  Checks if a floor line is empty. Will be true for a newly-created floor line.

  Examples:

  iex> Azul.Models.FloorLine.empty?(%Azul.Models.FloorLine{})
  true

  iex> Azul.Models.FloorLine.empty?(%Azul.Models.FloorLine{spaces: [:penalty]})
  false

  iex> Azul.Models.FloorLine.empty?(%Azul.Models.FloorLine{spaces: [:blue]})
  false
  """
  @spec empty?(t()) :: boolean()
  def empty?(floor_line) do
    floor_line.spaces == []
  end
end
