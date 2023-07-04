defmodule Azul.Game do
  @moduledoc """
  Provides functions for playing a game of Azul.
  """

  alias Azul.Models
  alias Azul.Models.TileColor

  @doc """
  A player takes tiles from a factory and places them on their pattern line.
  """
  @spec take_from_factory(
          Models.Game.t(),
          1..9,
          TileColor.t(),
          1..5
        ) :: {:ok, Models.Game.t()} | Azul.error()
  def take_from_factory(game, factory_index, color, row) do
    factory = Models.Game.factory(game, factory_index)

    case Models.Factory.take(factory, color) do
      {:ok, taken_tiles, _leftover_tiles, new_factory} ->
        {:ok,
         game
         |> Models.Game.update_factory(factory_index, new_factory)
         |> Models.Game.update_pattern_lines(game.active_player, row, taken_tiles)
         |> next_player}

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Ends the current player's turn and starts the next player's turn by setting
  the active player to the next player.

  Examples:

  iex> players = [%Azul.Models.Player{name: "Alice"}, %Azul.Models.Player{name: "Bob"}]
  iex> game = Azul.Models.Game.new(players, players |> Enum.at(1))
  iex> game = Azul.Game.next_player(game)
  iex> game.active_player
  %Azul.Models.Player{name: "Alice"}

  """
  @spec next_player(Models.Game.t()) :: Models.Game.t()
  def next_player(game) do
    %{players: players, active_player: p} = game

    {_p, player_idx} = Enum.with_index(players) |> Enum.find(fn {player, _} -> player == p end)
    next_player_idx = rem(player_idx + 1, length(players))

    %{game | active_player: Enum.at(players, next_player_idx)}
  end
end
