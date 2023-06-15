defmodule Azul.Models.PatternLinesTest do
  use ExUnit.Case, async: true
  doctest Azul.Models.PatternLines
  doctest Azul.Models.PatternLines.PatternLine

  setup_all do
    alice = %Azul.Models.Player{name: "Alice"}
    bob = %Azul.Models.Player{name: "Bob"}
    players = [alice, bob]
    {:ok, %{players: players, alice: alice, bob: bob}}
  end
end
