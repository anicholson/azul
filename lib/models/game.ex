require Logger

defmodule Azul.Models.Game do
  @moduledoc """
  Represents a game of Azul.
  A game has:
  * A list of players
  * A current player
  * A map of players to scores

  A Game is not intended to be interacted with directly.
  To create one, use `Azul.Models.Game.new/2`.

  To play the game, use the methods defined in `Azul.Game`.

  @see Azul.Game
  """

  @typedoc "Represents a game of Azul."
  @type t :: %__MODULE__{
          players: [Azul.Models.Player],
          current_player: Azul.Models.Player.t() | nil,
          scores: %{Azul.Models.Player.t() => integer()}
        }
  defstruct players: [], current_player: nil, scores: %{}

  @spec new([Azul.Models.Player], Azul.Models.Player.t() | nil) :: Azul.Models.Game.t()
  def new(players, start_player \\ nil) do
    scores = Enum.map(players, fn player -> {player, 0} end) |> Enum.into(%{})
    current_player = if start_player == nil do
      Enum.random(players)
    else
      Enum.find(players, fn player -> player == start_player end)
    end

    %Azul.Models.Game{players: players, current_player: current_player, scores: scores}
  end

  @spec score_for(
          Azul.Models.Game.t(),
          Azul.Models.Player.t()
        ) :: integer() | nil
  def score_for(%Azul.Models.Game{scores: scores}, player) do
    scores[player]
  end
end
