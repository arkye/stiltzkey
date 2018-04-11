defmodule StiltzkeyWeb.PoemView do
  use StiltzkeyWeb, :view

  alias Stiltzkey.Papyrus

  def author_username(%Papyrus.Poem{author: author}) do
    author.user.username
  end
end
