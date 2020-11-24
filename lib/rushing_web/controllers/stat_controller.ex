defmodule RushingWeb.StatController do
  use RushingWeb, :controller

  alias Rushing.Player
  alias Rushing.Player.Stat

  def index(conn, params) do
    stats = params |> params_to_query |> Player.list_stats()
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

  def export(conn, params) do
    conn = conn
    |> put_resp_header("content-disposition", "attachment; filename=players.csv")
    |> put_resp_content_type("text/csv")
    |> send_chunked(:ok)

    stream = params
    |> params_to_query
    |> Player.stream_stats
    |> Stream.map(&Map.drop(&1, [:__struct__, :__meta__]))
    |> CSV.Encoding.Encoder.encode(headers: true)

    {:ok, conn} = Rushing.Repo.transaction(fn() ->
      stream
      |> Enum.reduce_while(conn, fn (data, conn) ->
        case chunk(conn, data) do
          {:ok, conn} -> {:cont, conn}
          {:error, :closed} -> {:halt, conn}
        end
      end)
    end)

    conn
  end

  # Process HTTP request params into a Keyword list that our internal
  # Player module can use to construct an Ecto.Queryable
  defp params_to_query(params) do
    params
    |> Map.get("order", "")
    |> String.split(".")
    |> case do
      [""] -> [] # case where no order is set and Map.get/3 returns the default
      [field, "asc"] -> [order: [asc: String.to_existing_atom(field)]]
      [field, "desc"] -> [order: [desc: String.to_existing_atom(field)]]
      [field] -> [order: [asc: String.to_existing_atom(field)]]
      _ -> []
    end
    |> Keyword.put(:filter, %{player: Map.get(params, "player")})
  end
end
