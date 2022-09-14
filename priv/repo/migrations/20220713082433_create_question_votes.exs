defmodule FkcElixir.Repo.Migrations.CreateQuestionVotes do
  use Ecto.Migration

  def change do
    create table(:question_votes, primary_key: false) do
      add :vote, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :question_id, references(:questions, on_delete: :delete_all)
    end

    create unique_index(:question_votes, [:user_id, :question_id])

    create table(:answer_votes, primary_key: false) do
      add :vote, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :answer_id, references(:answers, on_delete: :delete_all)
    end

    create unique_index(:answer_votes, [:user_id, :answer_id])

    create table(:comment_votes, primary_key: false) do
      add :vote, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :comment_id, references(:comments, on_delete: :delete_all)
    end

    create unique_index(:comment_votes, [:user_id, :comment_id])

    create table(:a_comment_votes, primary_key: false) do
      add :vote, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :a_comment_id, references(:a_comments, on_delete: :delete_all)
    end

    create unique_index(:a_comment_votes, [:user_id, :a_comment_id])
  end
end
