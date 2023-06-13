defmodule AzulTest do
  use ExUnit.Case
  doctest Azul

  test "greets the world" do
    assert Azul.hello() == :world
  end
end
