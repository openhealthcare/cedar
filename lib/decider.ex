defmodule Cedar.Decider do
  alias Poison, as: JSON
  alias Cedar.Actions.Email, as: Email
  alias Cedar.Actions.ReturnToSender, as: ReturnToSender

  def start_link do
    sub = spawn_link &(decide/0)
    Phoenix.PubSub.subscribe(sub, "decision")
    {:ok, sub}
  end

  @doc"""
  Perform BEHAVIOUR for ACTION with PRE and POST, returning to ENDPOINT as required
  """
  def behave(behaviour, action, {pre, post, endpoint}) do
    Cedar.Matcher.process_block behaviour, action, {pre, post}
  end

  @doc"""
  Decide on what to do for change events.
  """
  def decide do
    receive do
      { :change, params } ->
        pre  = params[:pre]
        post  = params[:post]
        endpoint = params[:endpoint]

        IO.puts "Called change for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :change, {pre, post, endpoint}))

      { :admit, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called admit for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :admit, {%{}, episode, endpoint}))

      { :discharge, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called discharge for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :discharge, {episode, episode, endpoint}))

      { :transfer, params } ->
        pre  = params[:pre]
        post  = params[:post]
        endpoint    = params[:endpoint]

        IO.puts "Called transfer for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :transfer, {pre, post, endpoint}))

      _ ->
    end
    decide
  end
end
