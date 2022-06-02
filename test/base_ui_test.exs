defmodule BaseUITest do
  use ExUnit.Case
  doctest BaseUi

  test "greets the world" do
    assert BaseUi.hello() == :world
  end
end
