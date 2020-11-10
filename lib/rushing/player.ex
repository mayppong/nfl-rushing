defmodule Rushing.Player do
  @moduledoc """
  The Player context.
  """
  import Ecto.Query

  alias Rushing.Repo
  alias Rushing.Player.Stat

  @doc """
  Returns the list of stats.

  ## Examples

      iex> list_stats()
      [%Stat{}, ...]

  """
  def list_stats do
    Repo.all(Stat)
  end

  @spec list_stats(Tuple.t) :: [Ecto.Schema.t()]
  def list_stats(filter) do
    from(stats in Stat) |> build_stat_query(filter) |> Repo.all
  end

  @doc """
  Returns a stream of stats.

  ## Examples

      iex> stream_stats()
      #Stream<[]>

  To execute the stream, make sure it is wrapped within `Repo.transaction`.

  ## Examples

      stream = stream_stats()
      Repo.transaction(fn() ->
        stream |> Enum.take(1)
      end)

  """
  @spec stream_stats :: Enum.t
  def stream_stats, do: Repo.stream(Stat)
  def stream_stats(filter) do
    from(stats in Stat) |> build_stat_query(filter) |> Repo.stream
  end

  @doc """
  Gets a single stat.

  Raises `Ecto.NoResultsError` if the Stat does not exist.

  ## Examples

      iex> get_stat!(123)
      %Stat{}

      iex> get_stat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stat!(id), do: Repo.get!(Stat, id)

  @doc """
  Creates a stat.

  ## Examples

      iex> create_stat(%{field: value})
      {:ok, %Stat{}}

      iex> create_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stat(attrs \\ %{}) do
    %Stat{}
    |> Stat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stat.

  ## Examples

      iex> update_stat(stat, %{field: new_value})
      {:ok, %Stat{}}

      iex> update_stat(stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stat(%Stat{} = stat, attrs) do
    stat
    |> Stat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stat.

  ## Examples

      iex> delete_stat(stat)
      {:ok, %Stat{}}

      iex> delete_stat(stat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stat(%Stat{} = stat) do
    Repo.delete(stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stat changes.

  ## Examples

      iex> change_stat(stat)
      %Ecto.Changeset{data: %Stat{}}

  """
  def change_stat(%Stat{} = stat, attrs \\ %{}) do
    Stat.changeset(stat, attrs)
  end


  # Private method for resolving a map of fields and value to the WHERE clause to the query
  @spec build_stat_query(Ecto.Queryable.t, Tuple.t) :: Ecto.Queryable.t
  defp build_stat_query(base_query, [{:filter, filter} | tail]) do
    query = filter
    |> Enum.reduce(base_query, fn({k, v}, query) ->
      from q in query,
        where: ilike(field(q, ^k), ^"#{v}%")
    end)
    build_stat_query(query, tail)
  end

  # Private method for resolving a key-value pair to the ORDER BY clause to the query
  @spec build_stat_query(Ecto.Queryable.t, Tuple.t) :: Ecto.Queryable.t
  defp build_stat_query(base_query, [{:order, order} | tail]) do
    query = base_query
    |> order_by(^order)
    build_stat_query(query, tail)
  end

  defp build_stat_query(query, _), do: query
end
