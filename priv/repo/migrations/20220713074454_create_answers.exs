defmodule FkcElixir.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :description, :text
      add :verified, :boolean, default: false, null: false
      add :question_id, references(:questions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:question_id])
    create index(:answers, [:user_id])
  end
end
