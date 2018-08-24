defmodule SourceCounter do
  @moduledoc """
  代码行计数器
  """

  alias SourceCounter.Reader.Core, as: Reader
  alias SourceCounter.Formatter.Core, as: Formatter

  @spec count_file(Path.t()) :: map | tuple
  def count_file(path) do
    _do_count_file {path, ""}
  end
  defp _do_count_file({path, sub_path}) do
    path
    |> Path.join(sub_path)
    |> Path.expand()
    # todo 更多编码格式
    |> File.open([:read, :utf8])
    |> Reader.read()
    |> Formatter.format({path, sub_path})
  end

  @spec count_folder(Path.t()) :: any
  def count_folder(path) do
    _do_count_folder {path, ""}
  end
  defp _do_count_folder({path, sub_path}) do
    p = path |> Path.join(sub_path) |> Path.expand()

    if File.dir?(p) do
      p
      |> File.ls!()
      |> Enum.map(&({path, Path.join(sub_path, &1)}))
      |> peach(&_do_count_folder/1)
    else
      _do_count_file({path, sub_path})
    end
  end

  def peach(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.each(&Task.await/1)
  end
end
