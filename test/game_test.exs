defmodule Azul.Models.GameTest do
  use ExUnit.Case
  doctest Azul.Models.Game

  setup_all do
    alice = %Azul.Models.Player{name: "Alice"}
    bob = %Azul.Models.Player{name: "Bob"}
    players = [alice, bob]
    {:ok, %{players: players, alice: alice, bob: bob}}
  end

  test "#new with start_player", s do
    game = Azul.Models.Game.new(s[:players], s[:alice])

    assert game.current_player == s[:alice]
  end

  test "#new with no start_player", s do
    game = Azul.Models.Game.new(s.players)

    assert Enum.member?(s.players, game.current_player)
  end

  test "#score_for at start of game", s do
    game = Azul.Models.Game.new(s.players)
    assert Azul.Models.Game.score_for(game, s.alice) == 0
  end

  test "#score_for non-existent player", s do
    game = Azul.Models.Game.new(s.players)
    assert Azul.Models.Game.score_for(game, %Azul.Models.Player{name: "Charlie"}) == nil
  end
end
