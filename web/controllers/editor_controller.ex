defmodule Cedar.EditorController do
  use Phoenix.Controller

  plug :action

  def editor(conn, _params) do
    render conn, "editor.html"
  end

  def variables(conn, _params) do
    render conn, "variables.html"
  end

end
