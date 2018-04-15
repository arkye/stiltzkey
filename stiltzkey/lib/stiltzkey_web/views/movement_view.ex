defmodule StiltzkeyWeb.MovementView do
  use StiltzkeyWeb, :view

  alias Stiltzkey.Papyrus

  def leader_user(%Papyrus.Movement{leader: leader}) do
    leader.user
  end

  def leader_username(%Papyrus.Movement{leader: leader}) do
    leader.user.username
  end
end
