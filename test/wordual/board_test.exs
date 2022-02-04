defmodule Wordual.BoardTest do
  use ExUnit.Case
  import Wordual.Test.Support.Assertions

  alias Wordual.Board

  describe "init/0" do
    test "should intitialize the empty board" do
      is_initiailzied_board(Board.init())
    end
  end
end
