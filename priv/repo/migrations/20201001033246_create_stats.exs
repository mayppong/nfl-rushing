defmodule Rushing.Repo.Migrations.CreateStats do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :player, :string
      add :team, :string
      add :position, :string
      add :att, :integer
      add :att_per_game, :float
      add :yds, :integer
      add :avg, :float
      add :yds_per_game, :integer
      add :td, :integer
      add :lng, :integer
      add :first, :integer
      add :first_percent, :float
      add :twenty_plus, :integer
      add :forty_plus, :integer
      add :fum, :integer

      timestamps()
    end

  end
end
