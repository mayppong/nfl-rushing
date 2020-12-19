defmodule Rushing.Team do
  import Ecto.Query

  def get_teams() do
    query = from s in Rushing.Player.Stat,
      select: s.team,
      group_by: [s.team]

    query|> Repo.all
  end

  def get_summary() do
    query = from s in Rushing.Player.Stat,
      select: %{team: s.team, total_yds: sum(s.yds), avg_of_avg: avg(s.avg)},
      group_by: [s.team]

    query |> Repo.all
  end
end