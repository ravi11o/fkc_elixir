defmodule FkcElixir.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :title, :text
      add :author_id, references(:users, on_delete: :nothing)
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:author_id])
    create index(:comments, [:question_id])
  end
end
