defmodule FkcElixir.Forum.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :description, :string
    field :verified, :boolean, default: false
    belongs_to :question, FkcElixir.Forum.Question
    belongs_to :author, FkcElixir.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:description, :question_id, :author_id])
    |> validate_required([:description, :question_id, :author_id])
  end
end
