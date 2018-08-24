defmodule Mix.Tasks.Counter do
  use Mix.Task

  def run(args) do
    args
    |> List.wrap()
    |> SourceCounter.peach(
      &SourceCounter.count_folder(&1)
    )
  end
end
