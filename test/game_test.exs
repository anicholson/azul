defmodule Azul.GameTest do
  use ExUnit.Case, async: true
  doctest Azul.Game

  alias Azul.Game
  alias Azul.Models
  alias Azul.Models.{Factory, Player, TileColor}

  defmodule TakeFromFactory do
    @moduledoc false
    use ExUnit.Case, async: true

    test "take_from_factory/4" do
      players = [%Player{name: "Alice"}, %Player{name: "Bob"}]
      game = Models.Game.new(players, players |> Enum.at(1))
      game = game |> Game.take_from_factory(1, :blue, 1)
      assert game.active_player == Enum.at(players, 0)
    end
  end

  test "next_player/1" do
    players = [%Player{name: "Alice"}, %Player{name: "Bob"}]
    game = Models.Game.new(players, players |> Enum.at(1))
    game = game |> Game.next_player()
    assert game.active_player == Enum.at(players, 0)
  end
end
