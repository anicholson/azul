defmodule Azul.Models.Player do
  @type t :: %__MODULE__{
          name: String.t()
        }
  defstruct name: ""
end
