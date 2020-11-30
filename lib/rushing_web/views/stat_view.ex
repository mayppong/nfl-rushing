defmodule RushingWeb.StatView do
  use RushingWeb, :view

  @doc """
  ## Examples
      iex> build_order_param(%{"order" => "yds.asc"}, "td")
      "td.asc"

      iex> build_order_param(%{"order" => "yds.asc"}, "yds")
      "yds.desc"

  """
  @spec build_order_param(Map.t, String.t) :: String.t
  def build_order_param(params, field) do
    params
    |> Map.get("order", "")
    |> String.split(".")
    |> case do
      [""] -> "#{field}.asc"
      [^field, "asc"] -> "#{field}.desc"
      [^field, "desc"] -> "#{field}.asc"
      _ -> "#{field}.asc"
    end
  end

  @doc """
  ## Examples
      iex> build_longest_rush(%{lng: 75, lng_t: true})
      "75T"

      iex> build_longest_rush(%{lng: 75, lng_t: false})
      "75"

  """
  @spec build_longest_rush(Map.t) :: String.t
  def build_longest_rush(stat) do
    case stat.lng_t do
      true -> "#{stat.lng}T"
      false -> "#{stat.lng}"
    end
  end
end
