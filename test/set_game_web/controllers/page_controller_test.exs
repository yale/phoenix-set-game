defmodule SetGameWeb.PageControllerTest do
  use SetGameWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "SET"
  end
end
