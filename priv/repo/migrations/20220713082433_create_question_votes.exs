defmodule FkcElixir.Repo.Migrations.CreateQuestionVotes do
  use Ecto.Migration

  def change do
    create table(:question_votes, primary_key: false) do
      add :vote, :string
      add :u_id, references(:users, on_delete: :nothing)
      add :q_id, references(:questions, on_delete: :nothing)
    end

    create unique_index(:question_votes, [:u_id, :q_id])

    create table(:answer_votes, primary_key: false) do
      add :vote, :string
      add :u_id, references(:users, on_delete: :nothing)
      add :a_id, references(:answers, on_delete: :nothing)
    end

    create unique_index(:answer_votes, [:u_id, :a_id])

    create table(:comment_votes, primary_key: false) do
      add :vote, :string
      add :u_id, references(:users, on_delete: :nothing)
      add :c_id, references(:comments, on_delete: :nothing)
    end

    create unique_index(:comment_votes, [:u_id, :c_id])

    create table(:a_comment_votes, primary_key: false) do
      add :vote, :string
      add :u_id, references(:users, on_delete: :nothing)
      add :ac_id, references(:a_comments, on_delete: :nothing)
    end

    create unique_index(:a_comment_votes, [:u_id, :ac_id])
  end
end
