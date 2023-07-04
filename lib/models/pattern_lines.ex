defmodule Azul.Models.PatternLines do
  defmodule PatternLine do
    @typedoc """
    Represents a single pattern line in a game of Azul.
    """
    @type t :: %__MODULE__{
            color: Azul.Models.Tile.t() | nil,
            capacity: non_neg_integer(),
            filled: non_neg_integer()
          }
    defstruct color: nil, capacity: 0, filled: 0

    @doc """
    Creates a new pattern line with the given `capacity`.
    """
    @spec new(non_neg_integer()) :: Azul.Models.PatternLines.PatternLine.t()
    def new(capacity) do
      %Azul.Models.PatternLines.PatternLine{capacity: capacity}
    end

    @doc """
    Returns `true` if the pattern line is full, `false` otherwise.
    """
    @spec full?(Azul.Models.PatternLines.PatternLine.t()) :: boolean()
    def full?(%Azul.Models.PatternLines.PatternLine{capacity: capacity, filled: filled}) do
      capacity == filled
    end

    @doc """
    Returns `true` if the pattern line is empty, `false` otherwise.
    """
    @spec empty?(Azul.Models.PatternLines.PatternLine.t()) :: boolean()
    def empty?(%Azul.Models.PatternLines.PatternLine{filled: filled}) do
      filled == 0
    end

    @doc """
    Attempt to place `count` tiles of `color` on the pattern line.
    If the line is empty, the color will be set to `color`.
    If the color is the same as what is already on the row, the tiles will be added to the the row,
    and the line's `filled` field updated to match.
    Returns the updated line & the number of tiles that were successfully placed.

    Errors:

    If the color is different than what is already on the row, the tiles will not be placed
    and `:wrong_color` will be returned as the reason.

    Examples:

    iex> pattern_line = %Azul.Models.PatternLines.PatternLine{color: :blue, capacity: 5, filled: 0}
    iex> {:ok, new_line, 3} = Azul.Models.PatternLines.PatternLine.place(pattern_line, :blue, 3)
    iex> new_line.filled
    3

    iex> pattern_line = %Azul.Models.PatternLines.PatternLine{color: :blue, capacity: 5, filled: 0}
    iex> Azul.Models.PatternLines.PatternLine.place(pattern_line, :yellow, 3)
    {:error, :wrong_color}

    iex> pattern_line = %Azul.Models.PatternLines.PatternLine{color: :blue, capacity: 5, filled: 3}
    iex> {:ok, new_line, 2} = Azul.Models.PatternLines.PatternLine.place(pattern_line, :blue, 3)
    iex> new_line.filled
    5
    """
    @spec place(Azul.Models.PatternLines.PatternLine.t(), Azul.Models.Tile.t(), non_neg_integer()) ::
            {:ok, Azul.Models.PatternLines.PatternLine.t(), non_neg_integer()}
            | {:error, :wrong_color}
            | {:error, :too_many_tiles}
    def place(line, color, count) do
      case {line.color == nil || line.color == color, line.capacity - line.filled} do
        {true, avail} when avail >= count ->
          {:ok,
           %Azul.Models.PatternLines.PatternLine{
             line
             | color: color,
               filled: line.filled + count
           }, count}

        {true, avail} when avail < count ->
          {:ok, %Azul.Models.PatternLines.PatternLine{line | color: color, filled: line.capacity},
           avail}

        {false, _} ->
          {:error, :wrong_color}
      end
    end

    @doc """
    Returns true if the pattern line is assigned the given color, false otherwise.
    """
    @spec contains?(Azul.Models.PatternLines.PatternLine.t(), Azul.Models.Tile.t()) :: boolean()
    def contains?(%Azul.Models.PatternLines.PatternLine{color: color}, color) do
      true
    end

    def contains?(%Azul.Models.PatternLines.PatternLine{color: _c}, _color) do
      false
    end
  end

  @doc """
  Represents a player's pattern lines.

  The `lines` field is a list of `PatternLine`s, where the index of the list
  corresponds to the row number on the player's board.
  """
  @type t :: %__MODULE__{
          lines: [PatternLine.t()]
        }
  defstruct lines: []

  @doc """
  Creates a new set of PatternLines with the standard 5 rows of
  increasing capacity.

  Examples:

    iex> Azul.Models.PatternLines.new()
    %Azul.Models.PatternLines{
      lines: [
        %Azul.Models.PatternLines.PatternLine{capacity: 1, color: nil, filled: 0},
        %Azul.Models.PatternLines.PatternLine{capacity: 2, color: nil, filled: 0},
        %Azul.Models.PatternLines.PatternLine{capacity: 3, color: nil, filled: 0},
        %Azul.Models.PatternLines.PatternLine{capacity: 4, color: nil, filled: 0},
        %Azul.Models.PatternLines.PatternLine{capacity: 5, color: nil, filled: 0}
      ]
    }

  """
  @spec new() :: Azul.Models.PatternLines.t()
  def new() do
    %Azul.Models.PatternLines{lines: Enum.map(1..5, &PatternLine.new/1)}
  end

  @doc """
  Returns `true` if all of the pattern lines are empty, `false` otherwise.
  """
  @spec empty?(Azul.Models.PatternLines.t()) :: boolean()
  def empty?(%Azul.Models.PatternLines{lines: lines}) do
    Enum.all?(lines, &PatternLine.empty?/1)
  end

  @doc """
  Retrieves a pattern line from the set of pattern lines, 1-indexed.
  """
  @spec get(Azul.Models.PatternLines.t(), non_neg_integer()) ::
          Azul.Models.PatternLines.PatternLine.t() | nil
  def get(%Azul.Models.PatternLines{lines: lines}, index) do
    Enum.at(lines, index - 1)
  end
end
