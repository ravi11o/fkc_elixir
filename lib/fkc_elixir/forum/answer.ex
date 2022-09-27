defmodule FkcElixir.Forum.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Question, AComment, AnswerVote}
  alias FkcElixir.Accounts.User

  schema "answers" do
    field :description, :string
    field :verified, :boolean, default: false
    belongs_to :question, Question
    belongs_to :user, FkcElixir.Accounts.User
    has_many :a_comments, AComment

    many_to_many :answer_votes, User,
      join_through: AnswerVote,
      on_replace: :delete,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:description, :question_id, :user_id])
    |> validate_required([:description, :question_id, :user_id])
    |> validate_length(:description, min: 10)
  end
end
