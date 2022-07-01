defmodule FkcElixir.Repo.Migrations.AddTagsToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :tags, {:array, :integer}, default: []
    end
  end
end
