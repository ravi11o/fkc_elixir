defmodule FkcElixir.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :views, :integer
      add :description, :text

      timestamps()
    end
  end
end
