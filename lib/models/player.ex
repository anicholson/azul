defmodule Azul.Models.Player do
  @typedoc """
  Represents a player in a game of Azul.
  """
  @type t :: %__MODULE__{
          name: String.t()
        }
  defstruct name: ""
end
