defmodule Stiltzkey.Papyrus.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stiltzkey.Papyrus.{Enthusiast, Leader, Poet, Verse}

  schema "movements" do
    field :description, :string
    field :name, :string

    belongs_to :leader, Leader

    many_to_many :enthusiasts, Enthusiast, join_through: "movements_enthusiasts"
    many_to_many :poets, Poet, join_through: "movements_poets"
    many_to_many :verses, Verse, join_through: "movements_verses"

    timestamps()
  end

  @doc false
  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
