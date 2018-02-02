defmodule MapsMatrixApi do
  @moduledoc """
  MapsMAtrixApi is a simple interface to Googles Distance Matrix Api
  """

  @typedoc """
  A latitude and longitude pair in a tuple or comma-separated string format.
  """
  @type coordinate :: {latitude(), longitude()} | String.t()

  @typedoc """
  A address that will be transformed and geocoded to latitude and longitude.
  """
  @type address :: String.t()

  @type latitude :: number
  @type longitude :: number

  @typedoc """
  A tuple with an id of a known place.
  """
  @type place_id :: {:place_id, String.t()}

  @typedoc """
  A specific point, which can be an address, a latitude/longitude coord
  or a place id tupple.
  """
  @type waypoint :: address() | coordinate() | place_id()

  @type options :: keyword()

  @type mode :: String.t()

  @doc """
  Retrives the maps matrix from one point to another.

  Args:
    * `origin` - The coordinates latitude, longitude value, address, or place ID
      from which the calculation will be executed. If an address is passed  the 
      string will be transformed into a latitude, longitude coordinate.  

    * `destination` — The coordinates latitude, longitude value, address, or place ID
      from which the calculation will be executed. If an address is passed  the 
      string will be transformed into a latitude, longitude coordinate.

  Options:
    * `departure_time` — Specifies the desired time of departure. You
      can specify the time as an integer in seconds since midnight,
      January 1, 1970 UTC. Alternatively, you can specify a value of
      `now`, which sets the departure time to the current time (correct
      to the nearest second). The departure time may be specified in
      two cases:
      * For requests where the travel mode is transit: You can
        optionally specify one of `departure_time` or `arrival_time`.
        If neither time is specified, the `departure_time` defaults to
        now (that is, the departure time defaults to the current time).
      * For requests where the travel mode is driving: You can specify
        the `departure_time` to receive a route and trip duration
        (response field: `duration_in_traffic`) that take traffic
        conditions into account. This option is only available if the
        request contains a valid API key, or a valid Google Maps APIs
        Premium Plan client ID and signature. The `departure_time` must
        be set to the current time or some time in the future. It
        cannot be in the past.

    * `units` — Specifies the unit system to use displaying results.

  ## Examples

      iex> MapsMatrixApi.get()
      :world

  """
  # @spec directions(waypoint(), waypoint(), options()) :: Response.t()
  def data(origin, destination, options \\ []) do
    params =
      options
      |> Keyword.merge(origins: origin, destinations: destination)
      |> MapsMatrixApi.QueryBuilder.data()
  end

  @doc """
  Retrives the disntace from one point to another.

  Args:
    * `origin` - The coordinates latitude, longitude value, address, or place ID
      from which the calculation will be executed. If an address is passed  the 
      string will be transformed into a latitude, longitude coordinate.  

    * `destination` — The coordinates latitude, longitude value, address, or place ID
      from which the calculation will be executed. If an address is passed  the 
      string will be transformed into a latitude, longitude coordinate.

  Options:
    * `departure_time` — Specifies the desired time of departure. You
      can specify the time as an integer in seconds since midnight,
      January 1, 1970 UTC. Alternatively, you can specify a value of
      `now`, which sets the departure time to the current time (correct
      to the nearest second). The departure time may be specified in
      two cases:
      * For requests where the travel mode is transit: You can
        optionally specify one of `departure_time` or `arrival_time`.
        If neither time is specified, the `departure_time` defaults to
        now (that is, the departure time defaults to the current time).
      * For requests where the travel mode is driving: You can specify
        the `departure_time` to receive a route and trip duration
        (response field: `duration_in_traffic`) that take traffic
        conditions into account. This option is only available if the
        request contains a valid API key, or a valid Google Maps APIs
        Premium Plan client ID and signature. The `departure_time` must
        be set to the current time or some time in the future. It
        cannot be in the past.
        
    * `units` — Specifies the unit system to use displaying results.

  ## Examples

      iex> MapsMatrixApi.get()
      :world

  """
  def eta(origin, destination, options \\ []) do
    params =
      options
      |> Keyword.merge(origins: origin, destinations: destination)
      |> MapsMatrixApi.QueryBuilder.eta()
  end

  def distance(origin, destination, options \\ []) do
    params =
      options
      |> Keyword.merge(origins: origin, destinations: destination)
      |> MapsMatrixApi.QueryBuilder.distance()
  end

  def eta_distance(origin, destination, options \\ []) do
    params =
      options
      |> Keyword.merge(origins: origin, destinations: destination)
      |> MapsMatrixApi.QueryBuilder.eta_distance()
  end

  @spec timezone(coordinate(), options()) :: Response.t()
  def timezone(input, options \\ [])

  def timezone(location, options) when is_binary(location) do
    params = Keyword.merge(options, location: location, timestamp: :os.system_time(:seconds))
    GoogleMaps.get("timezone", params)
  end

  def timezone({lat, lng}, options) when is_number(lat) and is_number(lng) do
    timezone("#{lat},#{lng}", options)
  end
end
