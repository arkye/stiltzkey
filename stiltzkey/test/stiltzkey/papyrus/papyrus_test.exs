defmodule Stiltzkey.PapyrusTest do
  use Stiltzkey.DataCase

  alias Stiltzkey.Papyrus

  describe "poems" do
    alias Stiltzkey.Papyrus.Poem

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def poem_fixture(attrs \\ %{}) do
      {:ok, poem} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Papyrus.create_poem()

      poem
    end

    test "list_poems/0 returns all poems" do
      poem = poem_fixture()
      assert Papyrus.list_poems() == [poem]
    end

    test "get_poem!/1 returns the poem with given id" do
      poem = poem_fixture()
      assert Papyrus.get_poem!(poem.id) == poem
    end

    test "create_poem/1 with valid data creates a poem" do
      assert {:ok, %Poem{} = poem} = Papyrus.create_poem(@valid_attrs)
      assert poem.description == "some description"
      assert poem.title == "some title"
    end

    test "create_poem/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Papyrus.create_poem(@invalid_attrs)
    end

    test "update_poem/2 with valid data updates the poem" do
      poem = poem_fixture()
      assert {:ok, poem} = Papyrus.update_poem(poem, @update_attrs)
      assert %Poem{} = poem
      assert poem.description == "some updated description"
      assert poem.title == "some updated title"
    end

    test "update_poem/2 with invalid data returns error changeset" do
      poem = poem_fixture()
      assert {:error, %Ecto.Changeset{}} = Papyrus.update_poem(poem, @invalid_attrs)
      assert poem == Papyrus.get_poem!(poem.id)
    end

    test "delete_poem/1 deletes the poem" do
      poem = poem_fixture()
      assert {:ok, %Poem{}} = Papyrus.delete_poem(poem)
      assert_raise Ecto.NoResultsError, fn -> Papyrus.get_poem!(poem.id) end
    end

    test "change_poem/1 returns a poem changeset" do
      poem = poem_fixture()
      assert %Ecto.Changeset{} = Papyrus.change_poem(poem)
    end
  end
end
