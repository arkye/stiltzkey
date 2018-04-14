defmodule StiltzkeyWeb.PageControllerTest do
  use StiltzkeyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Stiltzkey!"
  end
end
