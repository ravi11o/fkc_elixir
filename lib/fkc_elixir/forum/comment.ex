defmodule FkcElixir.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :title, :string
    belongs_to :user, FkcElixir.Accounts.User
    belongs_to :question, FkcElixir.Forum.Question

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :user_id, :question_id])
    |> validate_required([:title, :user_id, :question_id])
  end
end
