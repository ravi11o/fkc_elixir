defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :description, :string
    field :title, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description])
    |> validate_required([:title, :views, :description])
  end
end
