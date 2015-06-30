defmodule Cedar.VariableController do
  use Cedar.Web, :controller
  alias Poison, as: JSON

  alias Cedar.VarServer
  alias Cedar.Variable

  def index(conn, _params) do
    variables = VarServer.all

    render conn, "index.html", variables: variables
  end

  def download(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("Content-Disposition", "attachment; filename=variables.json;")
    |> send_resp(200, JSON.encode!(VarServer.all))
  end

  def new(conn, _params) do
    changeset = Variable.changeset(%Variable{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"key" => key, "value" => value}) do


    VarServer.create(key, value)

    conn
    |> put_flash(:info, "Variable created successfully.")
    |> redirect(to: variable_path(conn, :index))

  end

  def show(conn, %{"id" => id}) do
    value = VarServer.lookup(id)
    render conn, "show.html", key: id, value: value
  end

  def edit(conn, %{"id" => id}) do
    value = VarServer.lookup(id)
    render conn, "edit.html", key: id, value: value
  end

  def update(conn,  %{"id" => key, "value" => value}) do
    VarServer.create(key, value)

    conn
    |> put_flash(:info, "Variable updated successfully.")
    |> redirect(to: variable_path(conn, :index))
  end

  def delete(conn, %{"id" => key}) do

    VarServer.delete(key)

    conn
    |> put_flash(:info, "Variable deleted successfully.")
    |> redirect(to: variable_path(conn, :index))
  end
end
