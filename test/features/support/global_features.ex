defmodule Azul.GlobalFeatures do
  @moduledoc false
  use Cabbage.Feature

  defgiven ~r/^(?<p1>.+?) and (?<p2>.+?) will play a game$/, %{p1: p1, p2: p2}, %{} do
    players = [%Azul.Models.Player{name: p1}, %Azul.Models.Player{name: p2}]
    {:ok, %{players: players}}
  end

  defwhen ~r/^(?<p>.+?) is the start player$/, %{p: p}, state do
    player = Enum.find(state.players, nil, fn player -> player.name == p end)
    assert player != nil
    {:ok, %{start_player: player}}
  end

  defthen ~r/^the game starts$/, _vars, state do
    game = Azul.Models.Game.new(state.players, state.start_player)
    {:ok, %{game: game}}
  end

  defthen ~r/^(?<p>.+?) is the active player$/, %{p: player}, %{
    game: game,
    start_player: start_player
  } do
    player = %Azul.Models.Player{name: player}
    assert game.active_player == start_player
  end

  defthen ~r/^we debug$/, _, state do
    keys = Map.keys(state)
    # credo:disable-for-next-line
    IO.inspect(state)
  end
end
