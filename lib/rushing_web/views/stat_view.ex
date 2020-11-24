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
end
