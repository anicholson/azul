defmodule Azul.Models.WallTest do
  use ExUnit.Case, async: true
  doctest Azul.Models.Wall
  doctest Azul.Models.Wall.Space

  test "has 25 spaces" do
    wall = Azul.Models.Wall.new()
    assert length(wall.spaces) == 25
  end
end
