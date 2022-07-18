defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Tag, QuestionTag, Answer}

  schema "questions" do
    field(:description, :string)
    field(:title, :string)
    field(:views, :integer, default: 0)
    field :tag, :string, virtual: true
    belongs_to(:user, FkcElixir.Accounts.User)
    has_many :answers, Answer
    many_to_many(:tags, Tag, join_through: QuestionTag, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description, :user_id, :tag])
    |> validate_required([:title, :description, :user_id])
  end
end
