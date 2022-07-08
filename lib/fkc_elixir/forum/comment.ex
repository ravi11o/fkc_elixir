defmodule FkcElixir.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :title, :string
    belongs_to :author, FkcElixir.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title, :author_id])
  end
end
