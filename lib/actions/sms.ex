defmodule Cedar.Actions.SMS do

  @moduledoc """
  Delivers SMS messages via txtlocal

  System should have the following ENV_VARs defined

    export SMS_USER="email@somewhere.com"
    export SMS_APIKEY="API Hash from https://control.txtlocal.co.uk/docs/"
  """
  @txtlocal_server "https://api.txtlocal.com/send/?"

  def deliver(numberlist, message) do
    numbers = numberlist |> Enum.map(fn x-> clean(x) end) |> Enum.join ","

    query = %{"username" => username, "hash" => hash,
              "numbers" => numbers, "sender" => "CEDAR",
              "message" => message}
    url = @txtlocal_server <> URI.encode_query(query)

    # Make GET request to url
    HTTPoison.get(url)
  end

  defp clean("0"<>number) do
    # Clean the number so that it only contains numbers. If it starts
    # with 0 then remove it and add 44
    "44#{number}"
  end

  defp clean(number) do
    number
  end

  defp username do
    System.get_env("SMS_USER")
  end

  defp hash do
    System.get_env("SMS_APIKEY")
  end

end