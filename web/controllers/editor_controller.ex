defmodule Cedar.EditorController do
  use Phoenix.Controller

  plug :action

  def editor(conn, _params) do
    render conn, "editor.html"
  end

end
