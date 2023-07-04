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
          active_player: Azul.Models.Player.t() | nil,
          scores: %{Azul.Models.Player.t() => integer()},
          walls: %{Azul.Models.Player.t() => Azul.Models.Wall.t()},
          pattern_lines: %{Azul.Models.Player.t() => Azul.Models.PatternLines.t()},
          floor_lines: %{Azul.Models.Player.t() => Azul.Models.FloorLines.t()},
          factories: [Azul.Models.Factory],
          marketplace: Azul.Models.Marketplace.t(),
          bag: Azul.Models.Bag.t()
        }
  defstruct players: [],
            active_player: nil,
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
        iex> game.active_player
        %Azul.Models.Player{name: "Alice"}

        iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
        iex> game = Azul.Models.Game.new(players)
        iex> Enum.member?(players, game.active_player)
        true
  """
  @spec new([Azul.Models.Player], Azul.Models.Player.t() | nil) :: Azul.Models.Game.t()
  def new(players, start_player \\ nil) do
    scores = Enum.map(players, fn player -> {player, 0} end) |> Enum.into(%{})

    active_player =
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
      active_player: active_player,
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

  @doc """
  Retrieves a `Azul.Models.Factory` from the `game` by its `index`, starting at *1*.
  If the `index` is out of bounds, returns `nil`.
  """
  @spec factory(
          Azul.Models.Game.t(),
          1..9
        ) :: Azul.Models.Factory.t() | nil
  def factory(%Azul.Models.Game{factories: factories}, index) do
    Enum.at(factories, index - 1, nil)
  end

  @doc """
  Updates the factory at (1-based) `index` in the `game` with the given `factory`.
  If the index is out of bounds, returns an error message.
  """
  @spec update_factory(
          Azul.Models.Game.t(),
          1..9,
          Azul.Models.Factory.t()
        ) :: {:ok, Azul.Models.Game.t()} | Azul.error()
  def update_factory(game, index, new_factory) do
    %{factories: factories} = game

    case Enum.at(factories, index - 1) do
      nil ->
        {:error, "No factory at index #{index}"}

      _ ->
        new_factories =
          Enum.with_index(factories, fn factory, i ->
            if i == index - 1 do
              new_factory
            else
              factory
            end
          end)

        {:ok, %{game | factories: new_factories}}
    end
  end

  @doc """
  Updates the pattern lines for the given `player` in the `game`,
  by placing the `tiles` on the given `row` index (1-based).
  """
  @spec update_pattern_lines(
          Azul.Models.Game.t(),
          Azul.Models.Player.t(),
          1..5,
          {Azul.Models.Tile.t(), 1..4}
        ) :: {:ok, Azul.Models.Game.t()} | Azul.error()
  def update_pattern_lines(game, player, row, {color, count}) do
    game
  end

  defp create_factories(number_of_factories) do
    Enum.map(1..number_of_factories, fn _ -> Azul.Models.Factory.new() end)
  end
end
