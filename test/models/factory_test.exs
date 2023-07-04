defmodule Azul.Models.FactoryTest do
  use ExUnit.Case, async: true
  doctest Azul.Models.Factory

  alias Azul.Models.{Factory, Player}

  setup do
    factory = %Factory{
      tiles: %{
        blue: 2,
        red: 1,
        white: 1,
        yellow: 0,
        black: 0
      }
    }

    {:ok, factory: factory}
  end

  test "take/2 happy path", %{factory: factory} do
    {:ok, taken_tiles, leftover_tiles, new_factory} = Factory.take(factory, :blue)

    assert taken_tiles == {
             :blue,
             2
           }

    assert leftover_tiles == %{
             blue: 0,
             red: 1,
             white: 1,
             yellow: 0,
             black: 0
           }

    assert new_factory == Factory.new()
  end

  test "take/2 when factory does not have color", %{factory: factory} do
    {:error, msg} = Factory.take(factory, :yellow)

    assert msg == "Factory has no yellow tiles to take"
  end

  test "take/2 when factory is empty" do
    factory = Factory.new()
    {:error, msg} = Factory.take(factory, :blue)

    assert msg == "Cannot take tiles from an empty factory"
  end
end
