defmodule Stiltzkey do
  @moduledoc """
  Stiltzkey keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc false
  def contributors do
    [
      [name: "Jonathan Moraes", github: "@arkye"],
      [name: "Edson Ma", github: "@edsonma"]
    ]
  end
end
