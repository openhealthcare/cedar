defmodule Cedar.EditorController do
  use Cedar.Web, :controller

  plug :action

  def editor(conn, _params) do
    render conn, "editor.html"
  end

end
