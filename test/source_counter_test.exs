defmodule SourceCounterTest do
  use ExUnit.Case
  doctest SourceCounter

  test "count_file" do
    assert SourceCounter.count_file("test/src/hello.c") == %{comment: 0, effective: 0, empty: 0, total: 9}
  end

  test "count_folder" do
    assert SourceCounter.count_folder("test/src/") == %{comment: 0, effective: 0, empty: 0, total: 9}
  end
end
