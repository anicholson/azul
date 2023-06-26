require Logger

defmodule Azul.Models.Game do
  @moduledoc """
  Represents a game of Azul.
  A game has:
  * A list of players
  * A current player
  * A map of players to scores
  * The walls for each player
  * The pattern lines for each player

  A Game is not intended to be interacted with directly.
  To create one, use `Azul.Models.Game.new/2`.

  To play the game, use the methods defined in `Azul.Game`.

  @see `Azul.Game`
  """

  @typedoc "Represents a game of Azul."
  @type t :: %__MODULE__{
          players: [Azul.Models.Player],
          current_player: Azul.Models.Player.t() | nil,
          scores: %{Azul.Models.Player.t() => integer()},
          walls: %{Azul.Models.Player.t() => Azul.Models.Wall.t()},
          pattern_lines: %{Azul.Models.Player.t() => Azul.Models.PatternLines.t()},
          floor_lines: %{Azul.Models.Player.t() => Azul.Models.FloorLines.t()},
          factories: [Azul.Models.Factory],
          marketplace: Azul.Models.Marketplace.t(),
          bag: Azul.Models.Bag.t()
        }
  defstruct players: [],
            current_player: nil,
            scores: %{},
            walls: %{},
            pattern_lines: %{},
            floor_lines: %{},
            factories: [],
            marketplace: Azul.Models.Marketplace.new(),
            bag: %Azul.Models.Bag{}

  @doc """
  Creates a new game of Azul with the `players` provided. If `start_player` is
  provided, that player will be the first player to play.

  ## Examples

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players, Enum.at(players, 0))
        iex> game.current_player
        %Azul.Models.Player{name: "Alice"}

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Enum.member?(players, game.current_player)
        true
  """
  @spec new([Azul.Models.Player], Azul.Models.Player.t() | nil) :: Azul.Models.Game.t()
  def new(players, start_player \\ nil) do
    scores = Enum.map(players, fn player -> {player, 0} end) |> Enum.into(%{})

    current_player =
      if start_player == nil do
        Enum.random(players)
      else
        Enum.find(players, fn player -> player == start_player end)
      end

    walls = Enum.map(players, fn player -> {player, Azul.Models.Wall.new()} end) |> Enum.into(%{})

    pattern_lines =
      Enum.map(players, fn player -> {player, Azul.Models.PatternLines.new()} end)
      |> Enum.into(%{})

      floor_lines =
      Enum.map(players, fn player -> {player, %Azul.Models.FloorLine{}} end)
      |> Enum.into(%{})

    %Azul.Models.Game{
      players: players,
      current_player: current_player,
      scores: scores,
      walls: walls,
      pattern_lines: pattern_lines,
      floor_lines: floor_lines,
      factories: create_factories(5)
    }
  end

  @doc """
  Returns the score for the given `player` in the `game`.
  If the player is not playing the game, returns `nil`.

  ## Examples

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Azul.Models.Game.score_for(game, Enum.at(players, 0))
        0

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Azul.Models.Game.score_for(game, %Azul.Models.Player{name: "Charlie"})
        nil
  """
  @spec score_for(
          Azul.Models.Game.t(),
          Azul.Models.Player.t()
        ) :: integer() | nil
  def score_for(%Azul.Models.Game{scores: scores}, player) do
    scores[player]
  end

  @doc """
  Returns the `Azul.Models.Wall` for the given `player` in the `game`.
  If the player is not playing the game, returns `nil`.

  ## Examples

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> wall = Azul.Models.Game.wall_for(game, Enum.at(players, 0))
        iex> Azul.Models.Wall.empty?(wall)
        true

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Azul.Models.Game.wall_for(game, %Azul.Models.Player{name: "Charlie"})
        nil
  """
  @spec wall_for(
          Azul.Models.Game.t(),
          Azul.Models.Player.t()
        ) :: Azul.Models.Wall.t() | nil
  def wall_for(game, player) do
    game.walls[player]
  end

  @doc """
  Returns the `Azul.Models.PatternLines` for the given `player` in the `game`.
  If the player is not playing the game, returns `nil`.

  ## Examples

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> pattern_lines = Azul.Models.Game.pattern_lines_for(game, Enum.at(players, 0))
        iex> Azul.Models.PatternLines.empty?(pattern_lines)
        true

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Azul.Models.Game.pattern_lines_for(game, %Azul.Models.Player{name: "Charlie"})
        nil
  """
  @spec pattern_lines_for(
          Azul.Models.Game.t(),
          Azul.Models.Player.t()
        ) :: Azul.Models.PatternLines.t() | nil
  def pattern_lines_for(game, player) do
    game.pattern_lines[player]
  end

  @doc """
  Returns the `Azul.Models.FloorLine` for the given `player` in the `game`.
  If the player is not playing the game, returns `nil`.

  ## Examples

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> floor_line = Azul.Models.Game.floor_line_for(game, Enum.at(players, 0))
        iex> Azul.Models.FloorLine.empty?(floor_line)
        true

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Azul.Models.Game.floor_line_for(game, %Azul.Models.Player{name: "Charlie"})
        nil
  """
  @spec floor_line_for(
          Azul.Models.Game.t(),
          Azul.Models.Player.t()
        ) :: Azul.Models.FloorLine.t() | nil
  def floor_line_for(game, player) do
    game.floor_lines[player]
  end

  defp create_factories(number_of_factories) do
    Enum.map(1..number_of_factories, fn _ -> Azul.Models.Factory.new() end)
  end
end
