defmodule ProvaTest do
  use ExUnit.Case
  doctest Prova

  test "greets the world" do
    assert Prova.hello() == :world
  end
end
