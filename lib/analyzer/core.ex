defmodule SourceCounter.Analyzer.Core do
  @moduledoc """
  分析代码成分
  """

  @type result() :: map
  @type context() :: map

  @spec analyze(string, context) :: {result, context}
  def analyze(string, context) do
    # TODO
    {%{total: 1}, context}
  end
end
