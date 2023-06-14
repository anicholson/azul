defmodule Azul.Features.SetupTest do
  use Cabbage.Feature, async: false, file: "setup.feature"

  defgiven ~r/^(?<p1>.+) and (?<p2>.+) will play a game$/, %{p1: p1, p2: p2}, %{} do
    players = [%Azul.Models.Player{name: p1}, %Azul.Models.Player{name: p2}]
    {:ok, %{players: players}}
  end

  defwhen ~r/^(?<p>.+) is the start player$/, %{p: p}, %{players: players} do
    player = Enum.find(players, nil, fn player -> player.name == p end)
    assert player != nil
    {:ok, %{players: players, start_player: player}}
  end

  defthen ~r/^the game starts$/, _vars, state do
    game = Azul.Models.Game.new(state.players, start_player: state.start_player)
    {:ok, %{game: game, players: state.players}}
  end

  defthen ~r/^(?<player>.+?)'s score is (?<s>\d+)$/, %{player: p, s: s}, state do
    p = %Azul.Models.Player{name: p}
    score = elem(Integer.parse(s), 0)
    assert Azul.Models.Game.score_for(state.game, p) == score
  end
end
