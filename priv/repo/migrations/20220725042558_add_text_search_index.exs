defmodule FkcElixir.Repo.Migrations.AddTextSearchIndex do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION pg_trgm")

    execute("""
    CREATE INDEX questions_trgm_idx ON questions USING GIN (to_tsvector('english',
      title || ' ' || description))
    """)
  end
end
