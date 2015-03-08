defmodule Cedar.PageController do
  use Cedar.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

  def not_found(conn, _params) do
    render conn, "not_found.html"
  end

  def error(conn, _params) do
    render conn, "error.html"
  end


end
