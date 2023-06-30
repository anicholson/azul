defmodule Azul.GlobalFeatures do
  use Cabbage.Feature

  defgiven ~r/^(?<p1>.+?) and (?<p2>.+?) will play a game$/, %{p1: p1, p2: p2}, %{} do
    players = [%Azul.Models.Player{name: p1}, %Azul.Models.Player{name: p2}]
    {:ok, %{players: players}}
  end

  defwhen ~r/^(?<p>.+?) is the start player$/, %{p: p}, %{players: players} do
    player = Enum.find(players, nil, fn player -> player.name == p end)
    assert player != nil
    {:ok, %{players: players, start_player: player}}
  end

  defthen ~r/^the game starts$/, _vars, state do
    game = Azul.Models.Game.new(state.players, state.start_player)
    {:ok, %{game: game}}
  end

  defthen ~r/^(?<p>.+?) is the active player$/, %{p: player}, state do
    player = %Azul.Models.Player{name: player}
    assert state.game.active_player == player
  end
end
