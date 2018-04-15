defmodule StiltzkeyWeb.VerseView do
  use StiltzkeyWeb, :view

  alias Stiltzkey.Papyrus

  def author_user(%Papyrus.Verse{author: author}) do
    author.user
  end

  def author_username(%Papyrus.Verse{author: author}) do
    author.user.username
  end
end
