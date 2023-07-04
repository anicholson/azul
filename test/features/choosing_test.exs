defmodule Azul.Features.ChoosingTest do
  use Cabbage.Feature, async: false, file: "choosing.feature"

  import_feature(Azul.GlobalFeatures)

  @type tile_table :: [
          %{color: String.t(), count: String.t()}
        ]
  @spec tile_table(tile_table()) :: Azul.Models.TileCollection.t()
  defp tile_table(table) do
    Enum.map(table, fn %{color: color, count: count} ->
      {String.to_atom(color), Integer.parse(count) |> elem(0)}
    end)
    |> Enum.into(%{})
  end

  defwhen ~r/^factory (?<factory>\d) has tiles:$/, %{factory: factory, table: tiles}, state do
    tile_collection = tile_table(tiles)

    new_factory = %Azul.Models.Factory{tiles: tile_collection}

    factory_index = Integer.parse(factory) |> elem(0)

    factories =
      Enum.with_index(state.game.factories)
      |> Enum.map(fn {factory, index} ->
        if index == factory_index do
          new_factory
        else
          factory
        end
      end)

    game = %{state.game | factories: factories}

    {:ok, %{game: game, modified_factory: factory_index}}
  end

  defwhen ~r/^(?<p>.+?) chooses (?<c>white|blue|black|red|yellow) tiles from factory (?<f>.)$/,
          %{p: player_name, c: color, f: factory},
          state do
    player = %Azul.Models.Player{name: player_name}
    color = String.to_existing_atom(color)
    factory = String.to_integer(factory)

    {:ok,
     %{
       turn: %{
         player: player,
         color: color,
         factory: factory,
         action: :take_from_factory
       }
     }}
  end

  defwhen ~r/^places them on row (?<r>\d+) of (?:his|her|their) pattern lines$/,
          %{r: row},
          state do
    row = String.to_integer(row)

    turn = Map.merge(state.turn, %{row: row})
    {:ok, %{turn: turn}}
  end

  defthen ~r/^takes (?:his|her|their) turn$/, _, %{turn: turn, game: game} do
    game =
      case turn.action do
        :take_from_factory ->
          Azul.Game.take_from_factory(game, turn.factory, turn.color, turn.row)

        _ ->
          raise "Unknown action: #{turn.action}"
      end

    {:ok, %{game: game}}
  end

  defthen ~r/^(?:his|her|their) turn ends$/, _, state do
    assert state.game.active_player != state.start_player
  end

  defthen ~r/^the tiles are moved to (?:his|her|their) pattern lines$/, _, %{
    game: game,
    start_player: player,
    turn: turn
  } do
    pattern_lines = Azul.Models.Game.pattern_lines_for(game, player)
    pattern_line = Azul.Models.PatternLines.get(pattern_lines, turn.row)

    assert Azul.Models.PatternLines.PatternLine.contains?(pattern_line, turn.color)
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

  defthen ~r/^the marketplace contains only the penalty tile$/, _vars, %{game: game} do
    assert Azul.Models.TileCollection.empty?(game.marketplace.tiles)
    assert Azul.Models.Marketplace.penalty?(game.marketplace)
  end
end
