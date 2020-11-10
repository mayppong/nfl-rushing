defmodule RushingWeb.StatController do
  use RushingWeb, :controller

  alias Rushing.Player
  alias Rushing.Player.Stat

  def index(conn, %{"player" => name}) do
    stats = Player.list_stats([filter: %{player: name}])
    render(conn, "index.html", stats: stats)
  end
  def index(conn, _params) do
    stats = Player.list_stats()
    render(conn, "index.html", stats: stats)
  end

  def new(conn, _params) do
    changeset = Player.change_stat(%Stat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"stat" => stat_params}) do
    case Player.create_stat(stat_params) do
      {:ok, stat} ->
        conn
        |> put_flash(:info, "Stat created successfully.")
        |> redirect(to: Routes.stat_path(conn, :show, stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stat = Player.get_stat!(id)
    render(conn, "show.html", stat: stat)
  end

  def edit(conn, %{"id" => id}) do
    stat = Player.get_stat!(id)
    changeset = Player.change_stat(stat)
    render(conn, "edit.html", stat: stat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "stat" => stat_params}) do
    stat = Player.get_stat!(id)

    case Player.update_stat(stat, stat_params) do
      {:ok, stat} ->
        conn
        |> put_flash(:info, "Stat updated successfully.")
        |> redirect(to: Routes.stat_path(conn, :show, stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", stat: stat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stat = Player.get_stat!(id)
    {:ok, _stat} = Player.delete_stat(stat)

    conn
    |> put_flash(:info, "Stat deleted successfully.")
    |> redirect(to: Routes.stat_path(conn, :index))
  end
end
