defmodule Cedar.Decider do
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
  def behave(behaviour, action, {pre, post, endpoint}, id \\ "") do
    success = Cedar.Matcher.process_block behaviour, action, {pre, post}, endpoint
    case success do
      true   -> Phoenix.PubSub.broadcast "audit", {:success, behaviour, pre, post, endpoint, id}
      false  -> Phoenix.PubSub.broadcast "audit", {:fail, behaviour, pre, post, endpoint, id}
    end
    success
  end

  @doc"""
  Decide on what to do for change events.
  """
  def decide do
    # Generate a unique id for the next message so we can group together
    # the steps we process.
    id = UUID.uuid4()

    receive do
      { :change, params } ->
        pre  = params[:pre]
        post  = params[:post]
        endpoint = params[:endpoint]

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :change, {pre, post, endpoint}, id))

      { :admit, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called admit for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :admit, {%{}, episode, endpoint}, id))

      { :discharge, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called discharge for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :discharge, {episode, episode, endpoint}, id))

      { :transfer, params } ->
        pre  = params[:pre]
        post  = params[:post]
        endpoint    = params[:endpoint]

        IO.puts "Called transfer for endpoint #{endpoint}"

        Path.wildcard("behaviours/*/*.behaviour")
          |> Enum.map(&(behave &1, :transfer, {pre, post, endpoint}, id))

      _ ->
    end
    decide
  end
end
