defmodule Mix.Tasks.Rushing.LoadData do
  @moduledoc """
  A mix task for importing JSON file into the database.
  Not super critical to the requirements, and could have been implemented
  directly in `/priv/repo/seeds.exs`. I guess this is just to flex that I
  have experience implementing mix tasks.
  """
  use Mix.Task

  @doc """
  Load player stats from a given JSON file to the database using Stream.
  This is the only reason in the entire application for including Jaxon,
  as it's the only library that supports JSON file streaming. Otherwise,
  `jason` is used everywhere as it's defaulted to by Phoenix.
  """
  @spec run(String.t) :: :ok
  def run(file_path) do
    Mix.Task.run("app.start")

    file_path
    |> File.stream!
    |> Jaxon.Stream.from_enumerable
    |> Jaxon.Stream.query([:root, :all])
    |> Stream.map(&Rushing.Player.Stat.from_json/1)
    |> Enum.each(fn(stream) ->
      # Check that it creates successfully. Could probably use `insert!` instead
      {:ok, _} = stream |> Rushing.Player.create_stat
    end)
  end
end