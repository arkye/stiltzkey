defmodule Stiltzkey.PapyrusTest do
  use Stiltzkey.DataCase

  describe "poems" do
  end

  describe "stanzas" do
    alias Stiltzkey.Papyrus.Stanza

    @valid_attrs %{context: "some context", description: "some description"}
    @update_attrs %{context: "some updated context", description: "some updated description"}
    @invalid_attrs %{context: nil, description: nil}

    def stanza_fixture(attrs \\ %{}) do
      {:ok, stanza} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Papyrus.create_stanza()

      stanza
    end

    test "list_stanzas/0 returns all stanzas" do
      stanza = stanza_fixture()
      assert Papyrus.list_stanzas() == [stanza]
    end

    test "get_stanza!/1 returns the stanza with given id" do
      stanza = stanza_fixture()
      assert Papyrus.get_stanza!(stanza.id) == stanza
    end

    test "create_stanza/1 with valid data creates a stanza" do
      assert {:ok, %Stanza{} = stanza} = Papyrus.create_stanza(@valid_attrs)
      assert stanza.context == "some context"
      assert stanza.description == "some description"
    end

    test "create_stanza/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Papyrus.create_stanza(@invalid_attrs)
    end

    test "update_stanza/2 with valid data updates the stanza" do
      stanza = stanza_fixture()
      assert {:ok, stanza} = Papyrus.update_stanza(stanza, @update_attrs)
      assert %Stanza{} = stanza
      assert stanza.context == "some updated context"
      assert stanza.description == "some updated description"
    end

    test "update_stanza/2 with invalid data returns error changeset" do
      stanza = stanza_fixture()
      assert {:error, %Ecto.Changeset{}} = Papyrus.update_stanza(stanza, @invalid_attrs)
      assert stanza == Papyrus.get_stanza!(stanza.id)
    end

    test "delete_stanza/1 deletes the stanza" do
      stanza = stanza_fixture()
      assert {:ok, %Stanza{}} = Papyrus.delete_stanza(stanza)
      assert_raise Ecto.NoResultsError, fn -> Papyrus.get_stanza!(stanza.id) end
    end

    test "change_stanza/1 returns a stanza changeset" do
      stanza = stanza_fixture()
      assert %Ecto.Changeset{} = Papyrus.change_stanza(stanza)
    end
  end
end
