defmodule RushingWeb.StatControllerTest do
  use RushingWeb.ConnCase

  alias Rushing.Player

  @create_attrs %{att: 42, att_per_game: 120.5, avg: 120.5, first: 42, first_percent: 120.5, forty_plus: 42, fum: 42, lng: 42, player: "some player", position: "some position", td: 42, team: "some team", twenty_plus: 42, yds: 42, yds_per_game: 42}
  @update_attrs %{att: 43, att_per_game: 456.7, avg: 456.7, first: 43, first_percent: 456.7, forty_plus: 43, fum: 43, lng: 43, player: "some updated player", position: "some updated position", td: 43, team: "some updated team", twenty_plus: 43, yds: 43, yds_per_game: 43}
  @invalid_attrs %{att: nil, att_per_game: nil, avg: nil, first: nil, first_percent: nil, forty_plus: nil, fum: nil, lng: nil, player: nil, position: nil, td: nil, team: nil, twenty_plus: nil, yds: nil, yds_per_game: nil}

  def fixture(:stat) do
    {:ok, stat} = Player.create_stat(@create_attrs)
    stat
  end

  describe "index" do
    test "lists all stats", %{conn: conn} do
      conn = get(conn, Routes.stat_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Stats"
    end
  end

  describe "new stat" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.stat_path(conn, :new))
      assert html_response(conn, 200) =~ "New Stat"
    end
  end

  describe "create stat" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.stat_path(conn, :create), stat: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.stat_path(conn, :show, id)

      conn = get(conn, Routes.stat_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Stat"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.stat_path(conn, :create), stat: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Stat"
    end
  end

  describe "edit stat" do
    setup [:create_stat]

    test "renders form for editing chosen stat", %{conn: conn, stat: stat} do
      conn = get(conn, Routes.stat_path(conn, :edit, stat))
      assert html_response(conn, 200) =~ "Edit Stat"
    end
  end

  describe "update stat" do
    setup [:create_stat]

    test "redirects when data is valid", %{conn: conn, stat: stat} do
      conn = put(conn, Routes.stat_path(conn, :update, stat), stat: @update_attrs)
      assert redirected_to(conn) == Routes.stat_path(conn, :show, stat)

      conn = get(conn, Routes.stat_path(conn, :show, stat))
      assert html_response(conn, 200) =~ "some updated player"
    end

    test "renders errors when data is invalid", %{conn: conn, stat: stat} do
      conn = put(conn, Routes.stat_path(conn, :update, stat), stat: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Stat"
    end
  end

  describe "delete stat" do
    setup [:create_stat]

    test "deletes chosen stat", %{conn: conn, stat: stat} do
      conn = delete(conn, Routes.stat_path(conn, :delete, stat))
      assert redirected_to(conn) == Routes.stat_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.stat_path(conn, :show, stat))
      end
    end
  end

  defp create_stat(_) do
    stat = fixture(:stat)
    %{stat: stat}
  end
end
