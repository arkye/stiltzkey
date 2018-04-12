defmodule StiltzkeyWeb.StanzaView do
  use StiltzkeyWeb, :view

  alias Stiltzkey.Papyrus

  def author_username(%Papyrus.Stanza{author: author}) do
    author.user.username
  end
end
