defmodule FkcElixir.Forum.AComment do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Answer, ACommentVote}
  alias FkcElixir.Accounts.User

  schema "a_comments" do
    field :description, :string
    belongs_to :user, User
    belongs_to :answer, Answer

    many_to_many :a_comment_votes, User,
      join_through: ACommentVote,
      on_replace: :delete,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(a_comment, attrs) do
    a_comment
    |> cast(attrs, [:description, :user_id, :answer_id])
    |> validate_required([:description, :user_id, :answer_id])
  end
end
