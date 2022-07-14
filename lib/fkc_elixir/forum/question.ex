defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Tag, QuestionTag}

  schema "questions" do
    field(:description, :string)
    field(:title, :string)
    field(:views, :integer, default: 0)
    belongs_to(:user, FkcElixir.Accounts.User)
    many_to_many(:tags, Tag, join_through: QuestionTag)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description, :user_id])
    |> validate_required([:title, :description, :user_id])
  end
end
