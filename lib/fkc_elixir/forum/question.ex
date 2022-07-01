defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0
    field :tags, {:array, :integer}, default: []

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description, :tags])
    |> validate_required([:title, :description])
  end
end
