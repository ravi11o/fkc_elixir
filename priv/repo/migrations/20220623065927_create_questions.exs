defmodule FkcElixir.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :views, :integer
      add :description, :text
      add :tags, {:array, :integer}, default: []
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
