defmodule FkcElixir.Forum.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

defmodule FkcElixir.Forum.QuestionTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions_tags" do
    belongs_to :question, FkcElixir.Forum.Question
    belongs_to :tag, FkcElixir.Forum.Tag

    timestamps()
  end

  @doc false
  def changeset(question_tag, attrs) do
    question_tag
    |> cast(attrs, [:question_id, :tag_id])
    |> validate_required([:question_id, :tag_id])
  end
end
