defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0
    field :tags, {:array, :integer}, default: []
    belongs_to :author, FkcElixir.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description, :tags, :author_id])
    |> validate_required([:title, :description, :author_id])
  end
end
