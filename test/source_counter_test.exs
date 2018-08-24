defmodule SourceCounterTest do
  use ExUnit.Case
  doctest SourceCounter

  test "count_file" do
    assert SourceCounter.count_file("test/src/hello.c") == %{
             comment: 11,
             effective: 7,
             empty: 4,
             total: 19
           }
  end

  test "count_folder" do
    assert SourceCounter.count_folder("test/src/") == :ok
  end
end
