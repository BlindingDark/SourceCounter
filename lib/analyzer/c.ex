defmodule SourceCounter.Analyzer.C do
  @moduledoc """
  C 系语言实现
  """

  @behaviour SourceCounter.Analyzer.Core

  alias SourceCounter.Analyzer.Core

  def pre_process(string) do
    _drop_string(string)
  end

  def is_empty({result, context}, string) do
    if _empty?(string) do
      {Core.put_empty(result), context}
    else
      {result, context}
    end
  end

  def is_effective({result, context}, string) do
    cond do
      Core.in_comment?(context) && (not _end_of_comment?(string))->
        {result, context}
      # 去掉 // 和 /* 之后的，以及 */ 之前的，如果 trim 后仍然存在则是有效行
      _has_effective?(string) ->
        {Core.put_effective(result), context}
      true ->
        {result, context}
    end
  end

  def is_comment({result, context}, string) do
    cond do
      # 如果在多行注释中，且为空行，空行 + 1，上下文不变
      Core.in_comment?(context) && _empty?(string) ->
        {Core.put_empty(result), context}
      # 如果在多行注释中，且为多行注释末尾，注释 + 1，多行注释结束
      Core.in_comment?(context) && _end_of_comment?(string) ->
        {
          Core.put_comment(result),
          Core.delete_in_comment(context)
        }
      # 如果在多行注释中，注释 + 1
      # 如果是注释，且为单行注释或一行的多行注释，注释 + 1
      Core.in_comment?(context) || _one_line_comment?(string) ->
        {Core.put_comment(result), context}

      # 如果是注释，且为多行注释的开始，注释 + 1，多行注释开始
      _begin_of_comment?(string) ->
        {
          Core.put_comment(result),
          Core.put_in_comment(context)
        }
      true ->
        {result, context}
    end
  end

  defp _empty?(string) do
    "" == String.trim(string)
  end

  defp _begin_of_comment?(string) do
    string |> String.contains?("/*")
  end

  defp _end_of_comment?(string) do
    string |> String.contains?("*/")
  end

  defp _normal_comment?(string) do
    String.contains?(string, "//")
  end

  defp _one_line_comment?(string) do
    (_begin_of_comment?(string) && _end_of_comment?(string))
    || _normal_comment?(string)
  end

  defp _has_effective?(string) do
    # 去掉 // 和 /* 之后的，以及 */ 之前的，如果 trim 后仍然存在则是有效行
    string
    |> _drop_suff("//")
    |> _drop_suff("/*")
    |> _drop_pre("*/")
    |> String.trim()
    |> (&("" != &1)).()
  end

  defp _drop_string(string) do
    # 删除字符串
    String.replace(string, ~r/\".*?\"/, "some string")
  end

  defp _drop_suff(string, splitter) do
    string
    |> String.split(splitter, parts: 2)
    |> List.first()
  end

  defp _drop_pre(string, splitter) do
    result = String.split(string, splitter, parts: 2)
    if 2 == length(result) do
      [_h, t] = result
      if String.contains?(t, splitter) do
        _drop_pre(t, splitter)
      else
        t
      end
    else
      string
    end
  end
end
