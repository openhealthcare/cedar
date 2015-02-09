defmodule Cedar.Actions.ReturnToSender do

  @actually_send Application.get_env(:cedar, :external_actions)

  @doc"""
  Send a MESSAGE to ENDPOINT

  Typically ENDPOINT is provided to an API call as the return
  path for messages.
  """
  def send(endpoint, {patient_id, episode_id}, value) do
    message = %{
                :status => :ok,
                :type => :msg,
                :value => value,
                :patient => patient_id,
                :episode =>episode_id
            }
    {:ok, as_json} =  Poison.encode message, string: true

    IO.puts as_json
    IO.puts endpoint

    if @actually_send do
      HTTPoison.start
      HTTPoison.post endpoint, as_json
    end

    {:ok, "Sent"}
  end

end
