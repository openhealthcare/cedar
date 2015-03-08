defmodule Cedar.EditorController do
  use Cedar.Web, :controller
  require Amnesia

  plug :action

  def editor(conn, _params) do
    render conn, "editor.html"
  end


  def variables(conn, _params) do

    vars = Amnesia.transaction! do
      Enum.group_by(~w{ant buffalo cat dingo}, &String.length/1)

      Enum.map(Db.Variable.stream |> Enum.reverse, fn(v) ->
        v
      end) |> Enum.group_by fn (x)->
        x.owner
      end
    end

    headers = Dict.keys(vars)

    render conn, "variables.html", variables: vars, headers: headers
  end

end
