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
  Hello world.

  ## Examples

      iex> MapsMatrixApi.hello
      :world

  """
  def hello do
    :world
  end
end
