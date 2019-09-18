defmodule DisplayRecipeTest do
  use ExUnit.Case
  doctest DisplayRecipe

  test "greets the world" do
    assert DisplayRecipe.hello() == :world
  end
end
