defmodule Metapede.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :topic_id, references(:topic)
      timestamps()
    end
  end
end
