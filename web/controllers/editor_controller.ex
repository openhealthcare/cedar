defmodule Cedar.EditorController do
  use Cedar.Web, :controller

  def editor(conn, _params) do
    render conn, "editor.html"
  end

  def download_rules(conn, _params) do
    files = Path.wildcard("behaviours/*/*.behaviour")
        |> Enum.map(&String.to_char_list/1)

    {:ok,{_filename, zipbin}} = :zip.create("rules.zip", files, [:memory])

    conn
    |> put_resp_content_type("application/zip")
    |> put_resp_header("Content-Disposition", "attachment; filename=rules.zip;")
    |> send_resp(200, zipbin)
  end

end
