defmodule Stiltzkey.Papyrus do
  @moduledoc """
  The Papyrus context.
  """

  import Ecto.Query, warn: false
  alias Stiltzkey.Repo

  alias Stiltzkey.Papyrus.{Poem, Author}
  alias Stiltzkey.Accounts

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
    Repo.all(Author)
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
end
