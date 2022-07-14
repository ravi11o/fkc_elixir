defmodule FkcElixir.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps()
    end

    create(index(:tags, ["lower(name)"], name: :tags_name_index, unique: true))

    create table(:questions_tags) do
      add :question_id, references(:questions)
      add :tag_id, references(:tags)
      timestamps()
    end

    create index(:questions_tags, [:question_id])
    create index(:questions_tags, [:tag_id])
    create unique_index(:questions_tags, [:question_id, :tag_id])
  end
end
