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

  describe "authors" do
    alias Stiltzkey.Papyrus.Author

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Papyrus.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Papyrus.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Papyrus.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Papyrus.create_author(@valid_attrs)
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Papyrus.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = Papyrus.update_author(author, @update_attrs)
      assert %Author{} = author
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Papyrus.update_author(author, @invalid_attrs)
      assert author == Papyrus.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Papyrus.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Papyrus.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Papyrus.change_author(author)
    end
  end
end
