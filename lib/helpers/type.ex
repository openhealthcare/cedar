defmodule Thing do

  @doc"""
  Will return a string describing what thing is by running it through the available
  is_foo predicates.
  """
  def is_what(thing) do
    case thing do
      result when is_atom(result) -> 
        "atom"
      result when is_binary(result) -> 
        "binary"
      result when is_bitstring(result) -> 
        "bitstring"
      result when is_boolean(result) -> 
        "boolean"
      result when is_float(result) -> 
        "float"
      result when is_function(result) -> 
        "function"
      result when is_function(result) -> 
        "function"
      result when is_integer(result) -> 
        "integer"
      result when is_list(result) -> 
        "list"
      result when is_map(result) -> 
        "map"
      result when is_number(result) -> 
        "number"
      result when is_pid(result) -> 
        "pid"
      result when is_port(result) -> 
        "port"
      result when is_reference(result) -> 
        "reference"
      result when is_tuple(result) -> 
        "tuple"
      _ ->
        "Who knows Larry, who knows. Now would be a good time to PANIC!"
    end
  end
end
