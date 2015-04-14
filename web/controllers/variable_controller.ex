defmodule Cedar.VariableController do
  use Cedar.Web, :controller

  alias Cedar.Variable

  plug :scrub_params, "variable" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    variables = Repo.all(Variable)
    render conn, "index.html", variables: variables
  end

  def new(conn, _params) do
    changeset = Variable.changeset(%Variable{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"variable" => variable_params}) do
    changeset = Variable.changeset(%Variable{}, variable_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Variable created successfully.")
      |> redirect(to: variable_path(conn, :index))
    else
      render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    variable = Repo.get(Variable, id)
    render conn, "show.html", variable: variable
  end

  def edit(conn, %{"id" => id}) do
    variable = Repo.get(Variable, id)
    changeset = Variable.changeset(variable)
    render conn, "edit.html", variable: variable, changeset: changeset
  end

  def update(conn, %{"id" => id, "variable" => variable_params}) do
    variable = Repo.get(Variable, id)
    changeset = Variable.changeset(variable, variable_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Variable updated successfully.")
      |> redirect(to: variable_path(conn, :index))
    else
      render conn, "edit.html", variable: variable, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    variable = Repo.get(Variable, id)
    Repo.delete(variable)

    conn
    |> put_flash(:info, "Variable deleted successfully.")
    |> redirect(to: variable_path(conn, :index))
  end
end
