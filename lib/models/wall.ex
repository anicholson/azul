defmodule Azul.Models.Wall do
  defmodule Space do
    @typedoc """
    Represents a space on a player's wall.
    """
    @type t :: %__MODULE__{
            color: Azul.tile(),
            filled: boolean()
          }
    defstruct color: :blue, filled: false
  end

  @doc """
  Specifies the default layout for a player's wall.
  """
  @default_layout [
    :blue,
    :yellow,
    :red,
    :black,
    :white,
    :white,
    :blue,
    :yellow,
    :red,
    :black,
    :black,
    :white,
    :blue,
    :yellow,
    :red,
    :red,
    :black,
    :white,
    :blue,
    :yellow,
    :yellow,
    :red,
    :black,
    :white,
    :blue
  ]

  @typedoc """
  Represents a player's wall.
  """
  @type t :: %__MODULE__{
          tiles: [Space.t()]
        }
  defstruct tiles: []

  @doc """
  Creates a new wall with the default layout. All
  `Space`s will be unfilled.
  """
  @spec new() :: Azul.Models.Wall.t()
  def new() do
    tiles = Enum.map(@default_layout, fn color -> %Space{color: color, filled: false} end)
    %Azul.Models.Wall{tiles: tiles}
  end

  @doc """
  Checks if the wall is empty. Returns `true` if all
  `Space`s are unfilled, `false` otherwise.
  """
  @spec empty?(Azul.Models.Wall.t()) :: boolean()
  def empty?(%Azul.Models.Wall{tiles: tiles}) do
    Enum.all?(tiles, fn space -> space.filled == false end)
  end
end
