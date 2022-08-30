defmodule FkcElixir.Forum.QuestionVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "question_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :u, FkcElixir.Accounts.User
    belongs_to :q, FkcElixir.Forum.Question
  end

  @doc false
  def changeset(question_vote, attrs) do
    question_vote
    |> cast(attrs, [:vote, :u_id, :q_id])
    |> validate_required([:vote, :u_id, :q_id])
    |> unique_constraint([:u_id, :q_id], name: :question_votes_u_id_q_id_index)
  end
end

defmodule FkcElixir.Forum.AnswerVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "answer_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :u, FkcElixir.Accounts.User
    belongs_to :a, FkcElixir.Forum.Answer
  end

  @doc false
  def changeset(answer_vote, attrs) do
    answer_vote
    |> cast(attrs, [:vote, :u_id, :a_id])
    |> validate_required([:vote, :u_id, :a_id])
    |> unique_constraint([:u_id, :a_id], name: :answer_votes_u_id_a_id_index)
  end
end

defmodule FkcElixir.Forum.CommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "comment_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :u, FkcElixir.Accounts.User
    belongs_to :c, FkcElixir.Forum.Comment
  end

  @doc false
  def changeset(comment_vote, attrs) do
    comment_vote
    |> cast(attrs, [:vote, :u_id, :c_id])
    |> validate_required([:vote, :u_id, :c_id])
    |> unique_constraint([:u_id, :c_id], name: :comment_votes_u_id_c_id_index)
  end
end

defmodule FkcElixir.Forum.ACommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "a_comment_votes" do
    field :vote, Ecto.Enum, values: [:up, :down]
    belongs_to :u, FkcElixir.Accounts.User
    belongs_to :ac, FkcElixir.Forum.AComment
  end

  @doc false
  def changeset(a_comment_vote, attrs) do
    a_comment_vote
    |> cast(attrs, [:vote, :u_id, :ac_id])
    |> validate_required([:vote, :u_id, :ac_id])
    |> unique_constraint([:u_id, :ac_id], name: :a_comment_votes_u_id_ac_id_index)
  end
end
