defmodule ExPeselTest do
  use ExUnit.Case
  doctest ExPesel

  test "PESEL validation only works for string not integer" do
    assert catch_error(ExPesel.valid?(12345678901)) == :function_clause
  end

  test "zombie PESEL is more than 123 years before than today: 2018-01-07" do
    # TODO:
  end
end
