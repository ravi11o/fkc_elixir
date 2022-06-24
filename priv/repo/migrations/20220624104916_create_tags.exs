defmodule FkcElixir.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps()
    end

    create(index(:tags, ["lower(name)"], name: :tags_name_index, unique: true))
  end
end
