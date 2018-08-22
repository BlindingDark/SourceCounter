defmodule SourceCounter do
  @moduledoc """
  代码行计数器
  """

  alias SourceCounter.Reader.Core, as: Reader
  alias SourceCounter.Formatter.Core, as: Formatter

  @spec count_file(Path.t()) :: nil
  def count_file(path) do
    path
    |> File.open([:read, :utf8]) # todo 更多编码格式
    |> Reader.read()
    |> Formatter.format()
  end

  @spec count_folder(Path.t()) :: nil
  def count_folder(path) do
    # TODO 多线程遍历
    nil
  end
end
