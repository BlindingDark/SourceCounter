defmodule SourceCounter.Formatter.Core do
  @moduledoc """
  格式化打印
  """

  @spec format({:ok | :error, map}) :: nil
  def format({:ok, map}) do
    IO.inspect map # todo 彩色
  end
  def format(error) do
    IO.inspect error
  end
end
