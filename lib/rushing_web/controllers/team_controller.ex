defmodule RushingWeb.TeamController do  
  use RushingWeb, :controller

  alias Rushing.Team

  def summary(conn, _params) do
    teams = Team.get_summary()
    render(conn, "index.html", teams: teams)
  end

end