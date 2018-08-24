defmodule SourceCounter.Formatter.Core do
  @moduledoc """
  格式化打印
  """

  @spec format({:ok | :error, map}, {String.t(), String.t()}) :: nil
  def format({:ok, map}, {path, sub_path}) do
    # file:src.cpp total:123 empty:123 effective:123 comment:123
    p = if "" == String.trim(sub_path) do
      path
    else
      sub_path
    end

    ["file:#{p}" | Enum.map([:total, :empty, :effective, :comment], &_f(map, &1))]
    |> Enum.join(" ")
    |> IO.puts()

    map
  end

  def format(error, {path, sub_path}) do
    IO.inspect({error, path <> sub_path})
  end

  defp _f(map, key) do
    count_number = Map.get(map, key) || 0
    "#{key}:#{count_number}"
  end
end
