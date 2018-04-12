defmodule Stiltzkey.Papyrus do
  @moduledoc """
  The Papyrus context.
  """

  import Ecto.Query, warn: false
  alias Stiltzkey.Repo

  alias Stiltzkey.Papyrus.{Author, Poem, Stanza, Verse}
  alias Stiltzkey.Accounts

  def ensure_author_exists(%Accounts.User{} = user) do
    %Author{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_author()
  end

  defp handle_existing_author({:ok, author}),  do: author
  defp handle_existing_author({:error, changeset}) do
    Repo.get_by!(Author, user_id: changeset.data.user_id)
  end

  @doc """
  Returns the list of poems.

  ## Examples

      iex> list_poems()
      [%Poem{}, ...]

  """
  def list_poems do
    Poem
    |> Repo.all()
    |> Repo.preload(author: [user: :credential])
  end

  @doc """
  Gets a single poem.

  Raises `Ecto.NoResultsError` if the Poem does not exist.

  ## Examples

      iex> get_poem!(123)
      %Poem{}

      iex> get_poem!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poem!(id) do
    Poem
    |> Repo.get!(id)
    |> Repo.preload(author: [user: :credential])
  end

  @doc """
  Creates a poem.

  ## Examples

      iex> create_poem(%{field: value})
      {:ok, %Poem{}}

      iex> create_poem(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poem(%Author{} = author, attrs \\ %{}) do
    %Poem{}
    |> Poem.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Repo.insert()
  end

  @doc """
  Updates a poem.

  ## Examples

      iex> update_poem(poem, %{field: new_value})
      {:ok, %Poem{}}

      iex> update_poem(poem, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poem(%Poem{} = poem, attrs) do
    poem
    |> Poem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Poem.

  ## Examples

      iex> delete_poem(poem)
      {:ok, %Poem{}}

      iex> delete_poem(poem)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poem(%Poem{} = poem) do
    Repo.delete(poem)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poem changes.

  ## Examples

      iex> change_poem(poem)
      %Ecto.Changeset{source: %Poem{}}

  """
  def change_poem(%Poem{} = poem) do
    Poem.changeset(poem, %{})
  end

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Author
    |> Repo.all()
    |> Repo.preload(user: :credential)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id) do
    Author
    |> Repo.get!(id)
    |> Repo.preload(user: :credential)
  end

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  @doc """
  Returns the list of stanzas.

  ## Examples

      iex> list_stanzas()
      [%Stanza{}, ...]

  """
  def list_stanzas do
    Stanza
    |> Repo.all()
    |> Repo.preload(author: [user: :credential])
    |> Repo.preload(:poem)
  end

  @doc """
  Gets a single stanza.

  Raises `Ecto.NoResultsError` if the Stanza does not exist.

  ## Examples

      iex> get_stanza!(123)
      %Stanza{}

      iex> get_stanza!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stanza!(id) do
    Stanza
    |> Repo.get!(id)
    |> Repo.preload(author: [user: :credential])
    |> Repo.preload(:poem)
  end

  @doc """
  Creates a stanza.

  ## Examples

      iex> create_stanza(%{field: value})
      {:ok, %Stanza{}}

      iex> create_stanza(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stanza(%Author{} = author, %Poem{} = poem, attrs \\ %{}) do
    %Stanza{}
    |> Stanza.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Ecto.Changeset.put_change(:poem_id, poem.id)
    |> Repo.insert()
  end

  @doc """
  Updates a stanza.

  ## Examples

      iex> update_stanza(stanza, %{field: new_value})
      {:ok, %Stanza{}}

      iex> update_stanza(stanza, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stanza(%Stanza{} = stanza, attrs) do
    stanza
    |> Stanza.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stanza.

  ## Examples

      iex> delete_stanza(stanza)
      {:ok, %Stanza{}}

      iex> delete_stanza(stanza)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stanza(%Stanza{} = stanza) do
    Repo.delete(stanza)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stanza changes.

  ## Examples

      iex> change_stanza(stanza)
      %Ecto.Changeset{source: %Stanza{}}

  """
  def change_stanza(%Stanza{} = stanza) do
    Stanza.changeset(stanza, %{})
  end

  @doc """
  Returns the list of verses.

  ## Examples

      iex> list_verses()
      [%Verse{}, ...]

  """
  def list_verses do
    Verse
    |> Repo.all()
    |> Repo.preload(author: [user: :credential])
    |> Repo.preload(:stanza)
  end

  @doc """
  Gets a single verse.

  Raises `Ecto.NoResultsError` if the Verse does not exist.

  ## Examples

      iex> get_verse!(123)
      %Verse{}

      iex> get_verse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_verse!(id) do
    Verse
    |> Repo.get!(id)
    |> Repo.preload(author: [user: :credential])
    |> Repo.preload(:stanza)
  end

  @doc """
  Creates a verse.

  ## Examples

      iex> create_verse(%{field: value})
      {:ok, %Verse{}}

      iex> create_verse(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_verse(%Author{} = author, %Stanza{} = stanza, attrs \\ %{}) do
    %Verse{}
    |> Verse.changeset(attrs)
    |> Ecto.Changeset.put_change(:author_id, author.id)
    |> Ecto.Changeset.put_change(:stanza_id, stanza.id)
    |> Repo.insert()
  end

  @doc """
  Updates a verse.

  ## Examples

      iex> update_verse(verse, %{field: new_value})
      {:ok, %Verse{}}

      iex> update_verse(verse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_verse(%Verse{} = verse, attrs) do
    verse
    |> Verse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Verse.

  ## Examples

      iex> delete_verse(verse)
      {:ok, %Verse{}}

      iex> delete_verse(verse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_verse(%Verse{} = verse) do
    Repo.delete(verse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking verse changes.

  ## Examples

      iex> change_verse(verse)
      %Ecto.Changeset{source: %Verse{}}

  """
  def change_verse(%Verse{} = verse) do
    Verse.changeset(verse, %{})
  end
end
