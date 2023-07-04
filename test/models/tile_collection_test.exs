defmodule Azul.Models.TileCollectionTest do
  use ExUnit.Case, async: true
  doctest Azul.Models.TileCollection

  test "from_list/1" do
    tiles = TileCollection.from_list([:blue, :blue, :red, :white, :white, :yellow])

    assert tiles == %{
             blue: 2,
             red: 1,
             white: 2,
             yellow: 1,
             black: 0
           }
  end
end
