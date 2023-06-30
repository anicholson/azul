defmodule Azul.Game do
  @moduledoc """
  Provides functions for playing a game of Azul.
  """

  @doc """
  A player takes tiles from a factory and places them on their pattern line.
  """
  @spec take_from_factory(
          Azul.Models.Game.t(),
          Azul.Models.Player.t(),
          Azul.Models.Factory.t(),
          Azul.Models.TileColor.t(),
          1..5
        ) :: Azul.Models.Game.t()
  def take_from_factory(game, player, factory, color, row) do
    game
  end
end
