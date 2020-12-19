defmodule Rushing.TeamTest do
  use Rushing.DataCase

  describe "teams" do
    alias Rushing.Team

    test "getting team list" do
      results = Team.get_team
      IO.inspect results
      assert results == []
    end

    test "getting summary of a team" do
      results = Team.get_summary()
      IO.inspect results
      assert List.get(results, :total_yds) == 12
      assert List.get(results, :avg_of_avg) == (4.5/2)
    end
  end

end