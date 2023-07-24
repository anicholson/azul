defmodule WeightedSample do
  @moduledoc """
  Represents a weighted sampling from a distribution map.
  """

  @doc """
  Randomly samples `count` items from the weighted list.

  Returns a 2-tuple with the following values:
  1. a list of the sampled items
  2. a new weighted map with the sampled items removed
  """
  @spec sample(%{any() => non_neg_integer()}, integer()) ::
          {list(), %{any() => non_neg_integer()}}
  def sample(distribution, count) do
    sample(distribution, count, [])
  end

  defp sample(distribution, count, bucket) do
    case count do
      0 ->
        {bucket, distribution}

      _ ->
        {sampled_value, new_distribution} = take_sample(distribution)
        sample(new_distribution, count - 1, [sampled_value | bucket])
    end
  end

  defp take_sample(distribution) do
    acc_list = Enum.scan(distribution, fn {k, w}, {_, w_sum} -> {k, w + w_sum} end)
    {_k, max} = List.last(acc_list)

    rand_value = Enum.random(1..max)

    sampled_value =
      Enum.find_value(acc_list, fn
        {k, w} when rand_value <= w -> k
        _ -> false
      end)

    new_distribution = Map.update!(distribution, sampled_value, &(&1 - 1))

    {sampled_value, new_distribution}
  end
end
