defmodule StiltzkeyWeb.StanzaControllerTest do
  use StiltzkeyWeb.ConnCase

  alias Stiltzkey.Papyrus

  @create_attrs %{context: "some context", description: "some description"}
  @update_attrs %{context: "some updated context", description: "some updated description"}
  @invalid_attrs %{context: nil, description: nil}

  def fixture(:stanza) do
    {:ok, stanza} = Papyrus.create_stanza(@create_attrs)
    stanza
  end

  describe "index" do
    test "lists all stanzas", %{conn: conn} do
      conn = get conn, stanza_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Stanzas"
    end
  end

  describe "new stanza" do
    test "renders form", %{conn: conn} do
      conn = get conn, stanza_path(conn, :new)
      assert html_response(conn, 200) =~ "New Stanza"
    end
  end

  describe "create stanza" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, stanza_path(conn, :create), stanza: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == stanza_path(conn, :show, id)

      conn = get conn, stanza_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Stanza"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, stanza_path(conn, :create), stanza: @invalid_attrs
      assert html_response(conn, 200) =~ "New Stanza"
    end
  end

  describe "edit stanza" do
    setup [:create_stanza]

    test "renders form for editing chosen stanza", %{conn: conn, stanza: stanza} do
      conn = get conn, stanza_path(conn, :edit, stanza)
      assert html_response(conn, 200) =~ "Edit Stanza"
    end
  end

  describe "update stanza" do
    setup [:create_stanza]

    test "redirects when data is valid", %{conn: conn, stanza: stanza} do
      conn = put conn, stanza_path(conn, :update, stanza), stanza: @update_attrs
      assert redirected_to(conn) == stanza_path(conn, :show, stanza)

      conn = get conn, stanza_path(conn, :show, stanza)
      assert html_response(conn, 200) =~ "some updated context"
    end

    test "renders errors when data is invalid", %{conn: conn, stanza: stanza} do
      conn = put conn, stanza_path(conn, :update, stanza), stanza: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Stanza"
    end
  end

  describe "delete stanza" do
    setup [:create_stanza]

    test "deletes chosen stanza", %{conn: conn, stanza: stanza} do
      conn = delete conn, stanza_path(conn, :delete, stanza)
      assert redirected_to(conn) == stanza_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, stanza_path(conn, :show, stanza)
      end
    end
  end

  defp create_stanza(_) do
    stanza = fixture(:stanza)
    {:ok, stanza: stanza}
  end
end
