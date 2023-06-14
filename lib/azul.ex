defmodule Azul do
  @moduledoc """
  Documentation for `Azul`.
  """

  @typedoc """
  A tile in the game. May be one of:
  * `:blue`
  * `:red`
  * `:yellow`
  * `:black`
  * `:white`
  """
  @type tile :: :blue | :red | :yellow | :black | :white
end
