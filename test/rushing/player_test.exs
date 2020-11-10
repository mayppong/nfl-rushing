defmodule Rushing.PlayerTest do
  use Rushing.DataCase

  describe "stats" do
    alias Rushing.Player
    alias Rushing.Player.Stat

    @valid_attrs %{att: 42, att_per_game: 120.5, avg: 120.5, first: 42, first_percent: 120.5, forty_plus: 42, fum: 42, lng: 42, player: "some player", position: "some position", td: 42, team: "some team", twenty_plus: 42, yds: 42, yds_per_game: 42}
    @update_attrs %{att: 43, att_per_game: 456.7, avg: 456.7, first: 43, first_percent: 456.7, forty_plus: 43, fum: 43, lng: 43, player: "some updated player", position: "some updated position", td: 43, team: "some updated team", twenty_plus: 43, yds: 43, yds_per_game: 43}
    @invalid_attrs %{att: nil, att_per_game: nil, avg: nil, first: nil, first_percent: nil, forty_plus: nil, fum: nil, lng: nil, player: nil, position: nil, td: nil, team: nil, twenty_plus: nil, yds: nil, yds_per_game: nil}

    def stat_fixture(attrs \\ %{}) do
      {:ok, stat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_stat()

      stat
    end

    test "list_stats/0 returns all stats" do
      stat = stat_fixture()
      assert Player.list_stats() == [stat]
    end

    test "list_stats/1 filtering by player's name" do
      stat = stat_fixture()
      assert Player.list_stats([filter: %{player: stat.player}]) |> hd == stat
    end

    test "list_stats/2 with descending sorting order" do
      stat = stat_fixture(%{att: 45, avg: 100})
      stat_fixture()
      assert Player.list_stats([filter: %{player: stat.player}, order: [desc: :att]]) |> hd == stat
    end

    test "list_stats/2 with ascending sorting order" do
      stat_fixture(%{att: 45, avg: 100})
      stat = stat_fixture()
      assert Player.list_stats([filter: %{player: stat.player}, order: [asc: :att]]) |> hd == stat
    end

    test "list_stats/2 with duplicate sorting order" do
      stat_fixture(%{att: 45, avg: 100})
      stat = stat_fixture()
      assert Player.list_stats([filter: %{player: stat.player}, order: [asc: :att, asc: :avg]]) |> hd == stat
    end

    test "stream_stats/0" do
      stat = stat_fixture()
      stream = Player.stream_stats
      {:ok, result} = Rushing.Repo.transaction(fn() ->
        stream |> Enum.to_list
      end)
      assert result |> hd == stat
    end

    test "get_stat!/1 returns the stat with given id" do
      stat = stat_fixture()
      assert Player.get_stat!(stat.id) == stat
    end

    test "create_stat/1 with valid data creates a stat" do
      assert {:ok, %Stat{} = stat} = Player.create_stat(@valid_attrs)
      assert stat.att == 42
      assert stat.att_per_game == 120.5
      assert stat.avg == 120.5
      assert stat.first == 42
      assert stat.first_percent == 120.5
      assert stat.forty_plus == 42
      assert stat.fum == 42
      assert stat.lng == 42
      assert stat.player == "some player"
      assert stat.position == "some position"
      assert stat.td == 42
      assert stat.team == "some team"
      assert stat.twenty_plus == 42
      assert stat.yds == 42
      assert stat.yds_per_game == 42
    end

    test "create_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_stat(@invalid_attrs)
    end

    test "update_stat/2 with valid data updates the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{} = stat} = Player.update_stat(stat, @update_attrs)
      assert stat.att == 43
      assert stat.att_per_game == 456.7
      assert stat.avg == 456.7
      assert stat.first == 43
      assert stat.first_percent == 456.7
      assert stat.forty_plus == 43
      assert stat.fum == 43
      assert stat.lng == 43
      assert stat.player == "some updated player"
      assert stat.position == "some updated position"
      assert stat.td == 43
      assert stat.team == "some updated team"
      assert stat.twenty_plus == 43
      assert stat.yds == 43
      assert stat.yds_per_game == 43
    end

    test "update_stat/2 with invalid data returns error changeset" do
      stat = stat_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_stat(stat, @invalid_attrs)
      assert stat == Player.get_stat!(stat.id)
    end

    test "delete_stat/1 deletes the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{}} = Player.delete_stat(stat)
      assert_raise Ecto.NoResultsError, fn -> Player.get_stat!(stat.id) end
    end

    test "change_stat/1 returns a stat changeset" do
      stat = stat_fixture()
      assert %Ecto.Changeset{} = Player.change_stat(stat)
    end
  end
end
