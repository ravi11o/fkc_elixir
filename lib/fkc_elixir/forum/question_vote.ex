defmodule FkcElixir.Forum.QuestionVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "question_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :user, FkcElixir.Accounts.User
    belongs_to :question, FkcElixir.Forum.Question
  end

  @doc false
  def changeset(question_vote, attrs) do
    question_vote
    |> cast(attrs, [:vote, :user_id, :question_id])
    |> validate_required([:vote, :user_id, :question_id])
    |> unique_constraint([:user_id, :question_id], name: :question_votes_user_id_question_id_index)
  end
end

defmodule FkcElixir.Forum.AnswerVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "answer_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :user, FkcElixir.Accounts.User
    belongs_to :answer, FkcElixir.Forum.Answer
  end

  @doc false
  def changeset(answer_vote, attrs) do
    answer_vote
    |> cast(attrs, [:vote, :user_id, :answer_id])
    |> validate_required([:vote, :user_id, :answer_id])
    |> unique_constraint([:user_id, :answer_id], name: :answer_votes_user_id_answer_id_index)
  end
end

defmodule FkcElixir.Forum.CommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "comment_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :user, FkcElixir.Accounts.User
    belongs_to :comment, FkcElixir.Forum.Comment
  end

  @doc false
  def changeset(comment_vote, attrs) do
    comment_vote
    |> cast(attrs, [:vote, :user_id, :comment_id])
    |> validate_required([:vote, :user_id, :comment_id])
    |> unique_constraint([:user_id, :comment_id], name: :comment_votes_user_id_comment_id_index)
  end
end

defmodule FkcElixir.Forum.ACommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "a_comment_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :user, FkcElixir.Accounts.User
    belongs_to :a_comment, FkcElixir.Forum.AComment
  end

  @doc false
  def changeset(a_comment_vote, attrs) do
    a_comment_vote
    |> cast(attrs, [:vote, :user_id, :a_comment_id])
    |> validate_required([:vote, :user_id, :a_comment_id])
    |> unique_constraint([:user_id, :a_comment_id],
      name: :a_comment_votes_user_id_a_comment_id_index
    )
  end
end
