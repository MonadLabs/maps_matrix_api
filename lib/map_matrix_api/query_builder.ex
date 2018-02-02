defmodule MapsMatrixApi.QueryBuilder do
  # use Tesla

  # plug(Tesla.Middleware.BaseUrl, "https://maps.googleapis.com/maps/api/distancematrix/json")

  def api_key do
    Application.get_env(:maps_matrix_api, :api_key) || System.get_env("MAPS_MATRIX_API_KEY")
  end

  def get(params, client \\ %Tesla.Client{}) do
    {key, params} = Keyword.pop(params, :key, api_key())
    {options, params} = Keyword.pop(params, :options, [])
    params = Keyword.put(params, :key, key)
    params = Enum.map(params, &transform_param/1)

    Tesla.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json",
      query: params
    ).body
  end

  def data(params) do
    get(params)
    |> serialize_body
  end

  def eta(params) do
    get(params)
    |> serialize_body
    |> get_eta
  end

  def distance(params) do
    get(params)
    |> serialize_body
    |> get_distance
  end

  def eta_distance(params) do
    get(params)
    |> serialize_body
    |> get_eta_distance
  end

  def serialize_body(response) do
    Jason.decode(response)
  end

  def get_eta(body) do
    with {:ok, data} <- body,
         %{"rows" => rows} <- data,
         [h | _t] <- rows,
         %{"elements" => elements} <- h,
         [head | _tail] <- elements,
         %{"duration" => duration_data} <- head,
         %{"value" => value} <- duration_data do
      {:ok, value}
    else
      _ -> :error
    end
  end

  def get_distance(body) do
    with {:ok, data} <- body,
         %{"rows" => rows} <- data,
         [h | _t] <- rows,
         %{"elements" => elements} <- h,
         [head | _tail] <- elements,
         %{"distance" => distance_data} <- head,
         %{"value" => value} <- distance_data do
      {:ok, value}
    else
      _ -> :error
    end
  end

  def get_eta_distance(body) do
    with {:ok, data} <- body,
         %{"rows" => rows} <- data,
         [h | _t] <- rows,
         %{"elements" => elements} <- h,
         [head | _tail] <- elements,
         %{"duration" => duration_data} <- head,
         %{"value" => duration} <- duration_data,
         %{"distance" => distance_data} <- head,
         %{"value" => distance} <- distance_data do
      {:ok, %{"duration" => duration, "distance" => distance}}
    else
      _ -> :error
    end
  end

  # def client(key) do
  #   Tesla.build_client([
  #     {Tesla.Middleware.Query, key: key}
  #   ])
  # end

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
