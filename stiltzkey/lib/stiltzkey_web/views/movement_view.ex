defmodule StiltzkeyWeb.MovementView do
  use StiltzkeyWeb, :view

  import StiltzkeyWeb.Helpers.Input.Decorator

  alias Stiltzkey.Papyrus

  def leader_user(%Papyrus.Movement{leader: leader}) do
    leader.user
  end

  def leader_username(%Papyrus.Movement{leader: leader}) do
    leader.user.username
  end
end
