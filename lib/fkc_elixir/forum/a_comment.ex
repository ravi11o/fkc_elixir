defmodule FkcElixir.Forum.AComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "a_comments" do
    field :description, :string
    belongs_to :author, FkcElixir.Accounts.User
    belongs_to :answer, FkcElixir.Forum.Answer

    timestamps()
  end

  @doc false
  def changeset(a_comment, attrs) do
    a_comment
    |> cast(attrs, [:description, :author_id, :answer_id])
    |> validate_required([:description, :author_id, :answer_id])
  end
end
