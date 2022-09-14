defmodule FkcElixir.Repo.Migrations.CreateAComments do
  use Ecto.Migration

  def change do
    create table(:a_comments) do
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :answer_id, references(:answers, on_delete: :delete_all)

      timestamps()
    end

    create index(:a_comments, [:user_id])
    create index(:a_comments, [:answer_id])
  end
end
