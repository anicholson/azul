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
    game = Azul.Models.Game.new(state.players, state.start_player)
    {:ok, %{game: game, players: state.players}}
  end

  defthen ~r/^(?<player>.+?)'s score is (?<s>\d+)$/, %{player: p, s: s}, state do
    p = %Azul.Models.Player{name: p}
    score = elem(Integer.parse(s), 0)
    assert Azul.Models.Game.score_for(state.game, p) == score
  end

  defthen ~r/^(?<player>.+?)'s wall is empty$/, %{player: p}, %{game: game} do
    p = %Azul.Models.Player{name: p}
    wall = Azul.Models.Game.wall_for(game, p)

    assert Azul.Models.Wall.empty?(wall)
  end

  defthen ~r/^(?<player>.+?)'s pattern lines are empty$/, %{player: p}, %{game: game} do
    p = %Azul.Models.Player{name: p}
    pattern_lines = Azul.Models.Game.pattern_lines_for(game, p)

    assert Azul.Models.PatternLines.empty?(pattern_lines)
  end

  defthen ~r/^(?<player>.+?)'s floor line is empty$/, %{player: p}, %{game: game} do
    p = %Azul.Models.Player{name: p}
    floor_line = Azul.Models.Game.floor_line_for(game, p)
    assert Azul.Models.FloorLine.empty?(floor_line)
  end

  defthen ~r/^there are (?<count>\d+) factories$/, %{count: count}, %{game: game} do
    count = elem(Integer.parse(count), 0)
    assert length(game.factories) == count
  end

  defthen ~r/^each factory is empty$/, _vars, %{game: game} do
    assert Enum.all?(game.factories, &Azul.Models.Factory.empty?/1)
  end

  defthen ~r/^the marketplace contains only the penalty tile$/, _vars, %{game: game} do
    assert Azul.Models.TileCollection.empty?(game.marketplace.tiles)
    assert Azul.Models.Marketplace.penalty?(game.marketplace)
  end

  defthen ~r/^the bag is full$/, _vars, %{game: %{bag: bag}} do
    assert bag.tiles == Azul.Models.TileCollection.full()
  end
end
