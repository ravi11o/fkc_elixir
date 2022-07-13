defmodule FkcElixir.Repo.Migrations.CreateAComments do
  use Ecto.Migration

  def change do
    create table(:a_comments) do
      add :description, :text
      add :author_id, references(:users, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :nothing)

      timestamps()
    end

    create index(:a_comments, [:author_id])
    create index(:a_comments, [:answer_id])
  end
end
