defmodule Mix.Tasks.Rushing.LoadDataTest do
  use Rushing.DataCase

  alias Mix.Tasks.Rushing.LoadData
  alias Rushing.Player.Stat

  describe "run/1" do
    test "running data loading task" do
      Application.app_dir(:rushing, "priv/repo/rushing_test.json")
      |> LoadData.run
      
      assert "Joe Banyard" == Rushing.Player.list_stats(%{player: "Joe Banyard"}) |> hd |> Map.get(:player)
    end
  end
end