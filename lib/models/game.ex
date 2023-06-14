require Logger

defmodule Azul.Models.Game do
  @type t :: %__MODULE__{
          players: [Azul.Models.Player],
          current_player: Azul.Models.Player.t() | nil,
          scores: %{Azul.Models.Player.t() => integer()}
        }
  defstruct players: [], current_player: nil, scores: %{}

  @spec new([Azul.Models.Player], [{:start_player, Azul.Models.Player.t() | nil}, ...]) :: Azul.Models.Game.t()
  def new(players, start_player: s) do
    scores = Enum.map(players, fn player -> {player, 0} end) |> Enum.into(%{})
    current_player = if s == nil do
      Enum.random(players)
    else
      Enum.find(players, fn player -> player == s end)
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
