defmodule Cedar.Rules do

  defp to_ruletree(tree, rules) do
    if length(rules) == 0 do
      tree
    else
      [h | t] = rules
      [dir | behaviour] = tl(String.split(h, "/")) # lose the behaviours folder
      IO.puts "#{inspect dir}, #{inspect behaviour}"
      if Dict.has_key? tree, dir do
        val = tree[dir] ++ behaviour
        tree = Dict.put tree, dir, val
      else
        tree = Dict.put tree, dir, behaviour
      end
      to_ruletree tree, t
    end
  end

  def ruletree do
    to_ruletree %{}, Path.wildcard("behaviours/*/*.behaviour")
  end

  def contents(path) do
    target = "behaviours/#{path}"
    IO.puts path
    {:ok, bin } = File.read target
    bin
  end

  def update(rule, contents) do
    File.write "behaviours/" <> rule, contents
  end

  @doc """
  The add function will add a new rule by creating a new file
  in the appropriate place (which is empty initially).  It will
  return true on success, false if the file already exists.

  TODO: Let it also specify the path
  """
  def add(rule, path) do

    p = "behaviours/sample/" <> rule <> ".behaviour"
    exists = File.exists?(p)
    if not exists do
      File.write p, ""
    end

    case exists do
      false -> ["sample","#{rule}.behaviour"]
      true -> [nil,nil]
    end
  end

end
