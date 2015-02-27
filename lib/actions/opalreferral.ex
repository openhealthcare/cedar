defmodule Cedar.Actions.OpalReferral do

  @doc"""
  Refer EPISODE_ID for PATIENT_ID to TARGET on OPAL_INSTANCE
  """
  def refer(target, episode_id, patient_id, endpoint) do
    IO.puts "Sending OPAL Referral to #{target}"
    referral_url = endpoint <> "api/v0.1/episode/refer"
    data = %{
             "patient"    => to_string(patient_id),
             "episode" => to_string(episode_id),
             "target"     => target
         }

    {_, body} = Poison.encode(data)

    HTTPoison.start
    case HTTPoison.post(referral_url, body ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body} } ->
        IO.puts body
        {:ok, 200}
      {:ok, %HTTPoison.Response{status_code: 404, body: _} } ->
        {:fail, "Not found :("}
      {:ok, %HTTPoison.Response{status_code: status, body: _} } ->
        IO.puts "Failed with #{status}"
        {:fail, "Unexpected status code: #{status}"}
      {:error, err} ->
        IO.puts "Unknown error condition :("
        IO.puts "#{inspect err}"
      thing ->
        IO.puts "Don't know what this is: #{inspect thing}"
        {:fail, "Unknokwn thing"}
    end

  end

end
