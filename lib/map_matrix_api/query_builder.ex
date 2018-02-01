defmodule MapsMatrixApi.QueryBuilder do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://maps.googleapis.com/maps/api/distancematrix/json")

  defp api_key do
    Application.get_env(:maps_matrix_api, :api_key) || System.get_env("MAPS_MATRIX_API_KEY")
  end

  def get_distance() do
    IO.puts("test")
  end

  def client(key) do
    Tesla.build_client([
      {Tesla.Middleware.Query, key: key}
    ])
  end

  defp transform_param({type, {lat, lng}})
       when type in [:origin, :destination] and is_number(lat) and is_number(lng) do
    {type, "#{lat},#{lng}"}
  end

  defp transform_param({type, {:place_id, place_id}})
       when type in [:origin, :destination] do
    {type, "place_id:#{place_id}"}
  end

  defp transform_param({:waypoints, "enc:" <> enc}) do
    {:waypoints, "enc:" <> enc}
  end

  defp transform_param({:waypoints, waypoints})
       when is_list(waypoints) do
    transform_param({:waypoints, Enum.join(waypoints, "|")})
  end

  # defp transform_param({:waypoints, waypoints}) do
  #   # @TODO: Encode the waypoints into encoded polyline.
  #   {:waypoints, "optimize:true|#{waypoints}"}
  # end

  defp transform_param(param), do: param
end
