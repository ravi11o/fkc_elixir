defmodule FkcElixir.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias FkcElixir.Forum.{Tag, QuestionTag, Answer, Comment, QuestionVote}
  alias FkcElixir.Accounts.User

  schema "questions" do
    field(:description, :string)
    field(:title, :string)
    field(:views, :integer, default: 0)
    field :slug, :string
    field :tag, :string, virtual: true
    belongs_to(:user, User)
    has_many :answers, Answer, on_delete: :delete_all
    has_many :comments, Comment, on_delete: :delete_all

    many_to_many :question_votes, User,
      join_through: QuestionVote,
      on_replace: :delete,
      on_delete: :delete_all

    many_to_many(:tags, Tag,
      join_through: QuestionTag,
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :views, :description, :user_id, :tag])
    |> validate_required([:title, :description, :user_id])
    |> generate_slug()
    |> unique_constraint([:slug])
  end

  defp generate_slug(changeset) do
    title = get_change(changeset, :title)

    if title do
      slug = "#{Slugger.slugify_downcase(title)}-#{:rand.uniform(1_000_000)}"
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end
end
