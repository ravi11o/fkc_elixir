defmodule FkcElixir.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :views, :integer
      add :description, :text
      add :slug, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:questions, [:slug])
  end
end
