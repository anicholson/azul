require Logger

defmodule Azul.Models.Game do
  defstruct players: [], current_player: nil, scores: %{}

  def new(players, start_player: s) do
    scores = Enum.map(players, fn player -> {player, 0} end) |> Enum.into(%{})
    current_player = if s == nil do
      Enum.random(players)
    else
      Enum.find(players, fn player -> player == s end)
    end

    %Azul.Models.Game{players: players, current_player: current_player, scores: scores}
  end

  def score_for(%Azul.Models.Game{scores: scores}, player) do
    scores[player]
  end
end
