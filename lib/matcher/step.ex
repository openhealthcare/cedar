defmodule Cedar.Matcher.Step do
    use Cedar.Macros
    alias Cedar.Actions, as: Actions


  @doc"""
  For a nested series of JSON objects MAP, find out if there is a
  property KEY with VALUE.

  KEY will be expressed as foo.bar.baz
  """
  def json_property_matches(key, map, value) do
    MapTraversal.map_apply(key, map, value,
      fn(x) -> Enum.any?(x, fn(y) -> y == value end) end,
      fn(x) -> x == value end)
  end

  @doc"""
  For a nested series of JSON objects MAP, find out if there is a
  property KEY with a value that contains VALUE.

  KEY will be expressed as foo.bar.baz
  """
  defp json_property_contains(key, map, value) do
    MapTraversal.map_apply(key, map, value,
      fn(x) -> Enum.any?(x, fn(y) -> String.contains? String.downcase(y), String.downcase(value) end) end,
      fn(x) -> String.contains? x, value end)
  end

  defp provide_result(success, err \\ "", {action, pre, post}) do
      case success do
        true ->
          {:ok, {pre,post}}
        false ->
          {:fail, err}
      end
  end

  defrule when_(_behaviour, [key, :is, value], {action, pre, post}) do
      match = json_property_matches key, post, value
      provide_result match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :is, :not, value], {action, pre, post}) do
      match = json_property_matches key, post, value
      provide_result !match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :was, value], {action, pre, post}) do
      match = json_property_matches key, pre, value
      provide_result match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :was, :not, value], {action, pre, post}) do
      match = json_property_matches key, pre, value
      provide_result !match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :did, :contain, value], {action, pre, post}) do
    match = json_property_contains key, pre, value
    provide_result match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :did, :not, :contain, value], {action, pre, post}) do
    match = json_property_contains key, pre, value
    provide_result !match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :contains, value], {action, pre, post}) do
    match = json_property_contains key, post, value
    provide_result match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :does, :not, :contain, value], {action, pre, post}) do
    match = json_property_contains key, post, value
    provide_result !match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [key, :changed, :to, value], {action, pre, post}) do
    was = json_property_matches( key, pre, value)
    is = json_property_matches key, post, value
    match = !was and is
    provide_result match, "Does not match", {action, pre, post}
  end

  defrule when_(_behaviour, [:admitted, :to, ward], {:admit, pre, post}) do
    match = json_property_matches "location.ward", post, ward
    provide_result match, "Does not match", {:admit, pre, post}
  end

  # def when_(behaviour, [], {action, pre, post}) do
  # end

  defrule then(_behaviour, [h|t], {action, pre, post}) do
      # We want to apply the action h and pass t as the args
      try do
        apply(Actions, h, [_behaviour, t, {action, pre, post}])
      rescue
        e -> IO.inspect e
      end
  end

end
