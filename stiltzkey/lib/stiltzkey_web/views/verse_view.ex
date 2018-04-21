defmodule StiltzkeyWeb.VerseView do
  use StiltzkeyWeb, :view

  import StiltzkeyWeb.Helpers.Input.Decorator

  alias Stiltzkey.Papyrus

  def author_user(%Papyrus.Verse{author: author}) do
    author.user
  end

  def author_username(%Papyrus.Verse{author: author}) do
    author.user.username
  end
end
