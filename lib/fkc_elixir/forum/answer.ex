defmodule FkcElixir.Forum.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Question, AComment}

  schema "answers" do
    field :description, :string
    field :verified, :boolean, default: false
    belongs_to :question, Question
    belongs_to :user, FkcElixir.Accounts.User
    has_many :a_comments, AComment

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
