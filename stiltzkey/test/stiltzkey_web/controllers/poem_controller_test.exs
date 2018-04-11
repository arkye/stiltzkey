defmodule StiltzkeyWeb.PoemControllerTest do
  use StiltzkeyWeb.ConnCase

  alias Stiltzkey.Papyrus

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:poem) do
    {:ok, poem} = Papyrus.create_poem(@create_attrs)
    poem
  end

  describe "index" do
    test "lists all poems", %{conn: conn} do
      conn = get conn, poem_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Poems"
    end
  end

  describe "new poem" do
    test "renders form", %{conn: conn} do
      conn = get conn, poem_path(conn, :new)
      assert html_response(conn, 200) =~ "New Poem"
    end
  end

  describe "create poem" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, poem_path(conn, :create), poem: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == poem_path(conn, :show, id)

      conn = get conn, poem_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Poem"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, poem_path(conn, :create), poem: @invalid_attrs
      assert html_response(conn, 200) =~ "New Poem"
    end
  end

  describe "edit poem" do
    setup [:create_poem]

    test "renders form for editing chosen poem", %{conn: conn, poem: poem} do
      conn = get conn, poem_path(conn, :edit, poem)
      assert html_response(conn, 200) =~ "Edit Poem"
    end
  end

  describe "update poem" do
    setup [:create_poem]

    test "redirects when data is valid", %{conn: conn, poem: poem} do
      conn = put conn, poem_path(conn, :update, poem), poem: @update_attrs
      assert redirected_to(conn) == poem_path(conn, :show, poem)

      conn = get conn, poem_path(conn, :show, poem)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, poem: poem} do
      conn = put conn, poem_path(conn, :update, poem), poem: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Poem"
    end
  end

  describe "delete poem" do
    setup [:create_poem]

    test "deletes chosen poem", %{conn: conn, poem: poem} do
      conn = delete conn, poem_path(conn, :delete, poem)
      assert redirected_to(conn) == poem_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, poem_path(conn, :show, poem)
      end
    end
  end

  defp create_poem(_) do
    poem = fixture(:poem)
    {:ok, poem: poem}
  end
end
