defmodule Rushing.Player.Stat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stats" do
    field :att, :integer
    field :att_per_game, :float
    field :avg, :float
    field :first, :integer
    field :first_percent, :float
    field :forty_plus, :integer
    field :fum, :integer
    field :lng, :integer
    field :lng_t, :boolean
    field :player, :string
    field :position, :string
    field :td, :integer
    field :team, :string
    field :twenty_plus, :integer
    field :yds, :integer
    field :yds_per_game, :float

    timestamps()
  end

  @doc """
  Remap keys from JSON to match struct keys.
  """
  @spec from_json(Map.t) :: Map.t
  def from_json(attrs) do
    [lng, lng_t] =
    with true <- is_binary(attrs["Lng"]),
         true <- String.ends_with?(attrs["Lng"], "T") do
      [String.replace(attrs["Lng"], "T", ""), true]
    else
      false -> [attrs["Lng"], false]
    end

    yds = attrs["Yds"]
    |> is_integer
    |> case do
      true -> attrs["Yds"]
      false -> attrs["Yds"] |> String.replace(",", "") |> String.to_integer()
    end

    %{
      player: attrs["Player"],
      team: attrs["Team"],
      position: attrs["Pos"],
      att: attrs["Att"],
      att_per_game: attrs["Att/G"],
      yds: yds,
      yds_per_game: attrs["Yds/G"],
      avg: attrs["Avg"],
      td: attrs["TD"],
      lng: lng,
      lng_t: lng_t,
      first: attrs["1st"],
      first_percent: attrs["1st%"],
      twenty_plus: attrs["20+"],
      forty_plus: attrs["40+"],
      fum: attrs["FUM"]
    }
  end

  @doc false
  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [:player, :team, :position, :att, :att_per_game, :yds, :avg, :yds_per_game, :td, :lng, :lng_t, :first, :first_percent, :twenty_plus, :forty_plus, :fum])
    |> validate_required([:player, :team, :position, :att, :att_per_game, :yds, :avg, :yds_per_game, :td, :lng, :lng_t, :first, :first_percent, :twenty_plus, :forty_plus, :fum])
  end
end
