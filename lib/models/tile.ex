defmodule Azul.Models.Tile do
  @typedoc """
  A tile in the game. May be one of:
  * `:blue`
  * `:red`
  * `:yellow`
  * `:black`
  * `:white`
  """
  @type t :: :blue | :red | :yellow | :black | :white

  @typedoc """
  The penalty tile. This tile starts each round in the center of the marketplace,
  and is worth -1 point at the end of the round to the player who holds it.
  """
  @type penalty :: :penalty
end
