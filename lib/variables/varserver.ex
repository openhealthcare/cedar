defmodule Cedar.VarServer do
  use GenServer
  alias Poison, as: JSON

  @filename "priv/vars/data.json"

  def start_link()do
    state = File.read!(@filename) |> JSON.decode
    GenServer.start_link(__MODULE__, state, [name: :varserver])
  end

  def lookup(name) do
    GenServer.call(:varserver, {:lookup, name})
  end

  def create(name, value) do
    GenServer.cast(:varserver, {:create, name, value})
  end

  def all do
    GenServer.call(:varserver, {:all})
  end

  ##############################
  # Genserver specific functions
  ###############################

  def init({:ok, state}) do
    {:ok, state}
  end

  def handle_call({:lookup, name}, _from, state) do
    {:reply, Dict.get(state, name), state}
  end

  def handle_call({:all}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:create, name, value}, state) do
    state = Dict.put(state, name, value )

    data = JSON.encode!(state) |> String.to_char_list
    File.write! @filename, data
    {:noreply, state}
  end

end
