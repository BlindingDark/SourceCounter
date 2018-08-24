defmodule SourceCounter do
  @moduledoc """
  代码行计数器
  """

  alias SourceCounter.Reader.Core, as: Reader
  alias SourceCounter.Formatter.Core, as: Formatter

  @spec count_file(Path.t()) :: map | tuple
  def count_file(path) do
    path
    # todo 更多编码格式
    |> File.open([:read, :utf8])
    |> Reader.read()
    |> Formatter.format(path)
  end

  @spec count_folder(Path.t()) :: any
  def count_folder(path) do
    if path |> Path.expand() |> File.dir?() do
      path
      |> File.ls!()
      |> Enum.map(&Path.join(path, &1))
      |> peach(&count_folder/1)
    else
      count_file(path)
    end
  end

  def peach(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.each(&Task.await/1)
  end
end
