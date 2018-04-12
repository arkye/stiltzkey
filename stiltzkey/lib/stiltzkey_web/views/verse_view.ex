defmodule StiltzkeyWeb.VerseView do
  use StiltzkeyWeb, :view

  alias Stiltzkey.Papyrus

  def author_username(%Papyrus.Verse{author: author}) do
    author.user.username
  end
end
