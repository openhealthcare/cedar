defmodule RulesTest do
  use ExUnit.Case


  test "get rule tree" do
    tree = Cedar.Rules.ruletree
    assert "sample.behaviour" in tree["global"]
    assert "my.behaviour" in tree["global"]
  end

end
