defmodule StiltzkeyWeb.StanzaView do
  use StiltzkeyWeb, :view

  import StiltzkeyWeb.Helpers.Input.Decorator

  alias Stiltzkey.Papyrus

  def author_username(%Papyrus.Stanza{author: author}) do
    author.user.username
  end
end
