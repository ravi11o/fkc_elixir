defmodule FkcElixir.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Question, CommentVote}
  alias FkcElixir.Accounts.User

  schema "comments" do
    field :title, :string
    belongs_to :user, User
    belongs_to :question, Question

    many_to_many :comment_votes, User,
      join_through: CommentVote,
      on_replace: :delete,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :user_id, :question_id])
    |> validate_required([:title, :user_id, :question_id])
  end
end
