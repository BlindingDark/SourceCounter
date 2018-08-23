defmodule SourceCounter.Analyzer.Core do
  @moduledoc """
  分析代码成分
  """

  @type result() :: map
  @type context() :: map

  @callback pre_process(String.t()) :: String.t()
  @callback is_empty({result, context}, String.t()) :: {result, context}
  @callback is_effective({result, context}, String.t()) :: {result, context}
  @callback is_comment({result, context}, String.t()) :: {result, context}

  @doc """
  context 标记当前行所在的上下文，其中
  source_type: :c 表示是 C 语言系
  in_comment: true 表示此行在多行注释内

  result 记录这一行的信息，格式：
  %{total: number, empty: number, effective: number, comment: number}
  """
  @spec analyze(String.t(), context) :: {result, context}
  def analyze(string, context) do
    module = _get_analyzer_module(context)
    _do_analyze(module, string, context)
  end

  defp _do_analyze(module, string, context) do
    string = module.pre_process(string)

    {%{}, context}
    |> module.is_effective(string)
    |> module.is_comment(string)
    |> module.is_empty(string)
    |> _put_total()
  end

  defp _get_analyzer_module(context) do
    source_type = Map.get(context, :source_type) || :c

    :source_counter
    |> Application.get_env(:analyzer)
    |> Map.get(source_type)
  end

  def in_comment?(context) do
    Map.get(context, :in_comment)
  end

  def put_in_comment(context) do
    Map.put(context, :in_comment, true)
  end

  def delete_in_comment(context) do
    Map.put(context, :in_comment, false)
  end

  def put_empty(result) do
    Map.put(result, :empty, 1)
  end

  def put_effective(result) do
    Map.put(result, :effective, 1)
  end

  def put_comment(result) do
    Map.put(result, :comment, 1)
  end

  defp _put_total({result, context}) do
    {Map.put(result, :total, 1), context}
  end
end
