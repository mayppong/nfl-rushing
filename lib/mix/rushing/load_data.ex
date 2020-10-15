defmodule Mix.Tasks.Rushing.LoadData do
  use Mix.Task

  @shortdoc "Load player stats from a given JSON file to the database."
  @spec run(String.t) :: :ok
  def run(file_path) do
    Mix.Task.run("app.start")

    file_path
    |> File.read!
    |> Jason.decode!
    |> Stream.each(fn(stat) -> 
      stat
      |> Rushing.Player.Stat.from_json
      |> Rushing.Player.create_stat
    end)
    |> Stream.run
  end
end