defmodule Cedar.Decider do

  def start_link do
    sub = spawn_link &(decide/0)
    Process.register(sub, :decider)
    {:ok, sub}
  end

  @doc"""
  Perform BEHAVIOUR for ACTION with PRE and POST, returning to ENDPOINT as required
  """
  def behave(behaviour, action, {pre, post, endpoint}, id \\ "") do
    success = Cedar.Matcher.process_block behaviour, action, {pre, post}, endpoint
    case success do
      true   -> Phoenix.PubSub.broadcast Cedar.PubSub, "audit", {:success, behaviour, pre, post, endpoint, id}
      false  -> Phoenix.PubSub.broadcast Cedar.PubSub, "audit", {:fail, behaviour, pre, post, endpoint, id}
    end
    success
  end

  def process_behaviours(action, {pre, post, endpoint}, id \\ "") do
    Path.wildcard("behaviours/*/*.behaviour")
      |> Enum.map(&(behave &1, action, {pre, post, endpoint}, id))
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

        Task.start fn ->
          process_behaviours( :change, {pre, post, endpoint}, id )
        end

      { :admit, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called admit for endpoint #{endpoint}"

        Task.start fn ->
          process_behaviours( :admit, {%{}, episode, endpoint}, id )
        end

      { :discharge, params } ->
        episode = params[:episode]
        endpoint    = params[:endpoint]

        IO.puts "Called discharge for endpoint #{endpoint}"

        Task.start fn ->
          process_behaviours( :discharge, {episode, episode, endpoint}, id )
        end

      { :transfer, params } ->
        pre  = params[:pre]
        post  = params[:post]
        endpoint    = params[:endpoint]

        IO.puts "Called transfer for endpoint #{endpoint}"

        Task.start fn ->
          process_behaviours( :transfer, {pre, post, endpoint}, id )
        end

      _ ->
    end
    decide
  end
end
