defmodule SourceCounter.Reader.Core do
  @moduledoc """
  读文件分析
  """
  alias SourceCounter.Analyzer.Core, as: Analyzer

  @init_count_result %{total: 0, empty: 0, effective: 0, comment: 0}
  @init_context %{}

  @doc """
  读取源码信息
  """
  @spec read({:ok, IO.device()} | {:error, any}) :: {:ok, map} | {:error, any}
  def read({:ok, pid}) do
    _do_read(pid, @init_context, @init_count_result)
  end
  def read(error), do: error

  defp _do_read(pid, context, acc) do
    case _read_line(pid) do
      :eof ->
        {:ok, acc}
      {:error, error_reason} ->
        {:error, error_reason}
      data ->
        {result, context} = Analyzer.analyze(data, context)
        _do_read(pid, context, _merge_result(result, acc))
    end
  end

  defp _merge_result(result, acc) do
    Enum.reduce(result, acc, fn({k, v}, acc) ->
      Map.update!(acc, k, &(&1 + v))
    end)
  end

  defp _read_line(pid) do
    IO.read(pid, :line)
  end
end
